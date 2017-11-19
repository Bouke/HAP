import Foundation
import HKDF
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.endpoints.characteristics")

func characteristics(device: Device) -> Application {
    return { (connection, request) in
        switch request.method {
        case "GET":
            let queryItems = request.urlComponents.queryItems

            guard
                let id = queryItems?.first(where: {$0.name == "id"})?.value
                else {
                    return .badRequest
            }

            let meta = queryItems?.first(where: {$0.name == "meta"})?.value == "1"
            let perms = queryItems?.first(where: {$0.name == "perms"})?.value == "1"
            let type = queryItems?.first(where: {$0.name == "type"})?.value == "1"
            let ev = queryItems?.first(where: {$0.name == "ev"})?.value == "1"

            let paths = id.components(separatedBy: ",").map { $0.components(separatedBy: ".").flatMap { Int($0) } }

            var serialized: [[String: Any]] = []
            for path in paths {
                guard path.count == 2 else {
                    return .badRequest
                }

                guard
                    let characteristic = device.accessories.first(where: {$0.aid == path[0]})?.services.flatMap({$0.characteristics.filter({$0.iid == path[1]})}).first
                    else {
                        serialized.append(["aid": path[0], "iid": path[1], "status": HAPStatusCodes.resourceDoesNotExist.rawValue])
                        break
                }
                guard characteristic.permissions.contains(.read) else {
                    logger.info("\(characteristic) has no read permission")
                    serialized.append(["aid": path[0], "iid": path[1], "status": HAPStatusCodes.writeOnly.rawValue])
                    continue
                }

                var body = ["aid": path[0], "iid": path[1], "value": characteristic.getValue() ?? NSNull()]
                if meta {
                    if let maxValue = characteristic.maxValue {
                        body["maxValue"] = maxValue.jsonValueType
                    }
                    if let minValue = characteristic.minValue {
                        body["minValue"] = minValue.jsonValueType
                    }
                    if let unit = characteristic.unit {
                        body["unit"] = unit.jsonValueType
                    }
                    if let minStep = characteristic.minStep {
                        body["minStep"] = minStep.jsonValueType
                    }
                    if let maxLen = characteristic.maxLength {
                        body["maxLen"] = maxLen.jsonValueType
                    }
                }
                if perms {
                    body["perms"] = characteristic.permissions.map { $0.rawValue }
                }
                if type {
                    body["type"] = characteristic.type.rawValue
                }
                if ev {
                    body["ev"] = characteristic.permissions.contains(.events)
                }
                serialized.append(body)
            }

            /* HAP Specification 5.7.3.2
             If all reads succeed, the accessory must respond with a 200 OK HTTP Status Code and a JSON body.
             The body must contain a JSON object with the value and instance ID of each characteristic.

             If an error occurs when attempting to read any characteristics, e.g. the physical devices
             represented by the characteristics to be read were unreachable,
             the accessory must respond with a 207 Multi-Status HTTP Status Code
             and each characteristic object must contain a "status" entry.
             Characteristics that were read successfully must have a "status" of 0 and "value".
             Characteristics that were read unsuccessfully must contain
             a non-zero "status" entry and must not contain a "value" entry.
             */

            var responseStatus: Response.Status = .ok
            if serialized.first(where: {$0.keys.contains("status")}) != nil {
                for (index, element) in serialized.enumerated() where element["status"] == nil {
                    serialized[index]["status"] = HAPStatusCodes.success.rawValue
                }
                responseStatus = .multiStatus
            }

            do {
                let json = try JSONSerialization.data(withJSONObject: ["characteristics": serialized], options: [])
                return Response(status: responseStatus, data: json, mimeType: "application/hap+json")
            } catch {
                logger.error("Could not serialize object", error: error)
                return .internalServerError
            }

        case "PUT":
            var body = Data()
            guard
                let _  = try? request.readAllData(into: &body),
                let decoded = try? JSONDecoder().decode(Protocol.CharacteristicContainer.self, from: body) else
            {
                    logger.warning("Could not decode JSON")
                    return .badRequest
            }
            var statuses = [Protocol.Characteristic]()
            for item in decoded.characteristics {
                var status = Protocol.Characteristic(aid: item.aid, iid: item.iid)
                guard let characteristic = device.accessories
                    .first(where: {$0.aid == item.aid})?
                    .services
                    .flatMap({$0.characteristics.filter({$0.iid == item.iid})})
                    .first else {
                    return .unprocessableEntity
                }

                // At least one of "value" or "ev" will be present in the characteristic write request object
                guard item.value != nil || item.ev != nil else {
                    return .badRequest
                }

                // set new value
                VALUE: if let value = item.value {
                    guard characteristic.permissions.contains(.write) else {
                        logger.info("\(characteristic) has no write permission")
                        status.status = .readOnly
                        break VALUE  // continue and process other items
                    }

                    logger.debug("Setting \(characteristic) to new value \(value) (type: \(type(of: value)))")
                    do {
                        switch value {
                        case let .string(value):
                            try characteristic.setValue(value, fromConnection: connection)
                        case let .number(number):
                            try characteristic.setValue(number, fromConnection: connection)
                        }
                        status.status = .success
                    } catch {
                        logger.warning("Could not set value of type \(type(of: value)): \(error)")
                        status.status = .invalidValue
                       break VALUE
                    }

                    // notify listeners
                    device.notify(characteristicListeners: characteristic, exceptListener: connection)
                }

                // toggle events for this characteristic on this connection
                if let events = item.ev {
                    guard characteristic.permissions.contains(.events) else {
                        status.status = .notificationNotSupported
                        statuses.append(status)
                        break
                    }
                    if events {
                        device.add(characteristic: characteristic, listener: connection)
                        logger.debug("Added listener for \(characteristic)")
                    } else {
                        device.remove(characteristic: characteristic, listener: connection)
                        logger.debug("Removed listener for \(characteristic)")
                    }
                    status.status = .success
                }

                statuses.append(status)
            }

            /* HAP Specification 5.7.2.3
             If an error occurs when attempting to write any characteristics, e.g. the physical devices
             represented by the characteristics to be written were unreachable,
             the accessory must respond with a 207 Multi-Status HTTP Status Code
             and each response object must contain a "status" entry.
             Characteristics that were written successfully must have a "status" of 0 and
             characteristics that failed to be written must have a non-zero "status" entry.

             For single write the error code is 400 Bad Request
             */

            let hasErrors = !statuses.filter({ $0.status != .success }).isEmpty
            guard !hasErrors else {
                do {
                    let json = try JSONEncoder().encode(Protocol.CharacteristicContainer(characteristics: statuses))
                    return Response(status: statuses.count == 1 ? .badRequest : .multiStatus, data: json, mimeType: "application/hap+json")
                } catch {
                    logger.error("Could not serialize object", error: error)
                    return .internalServerError
                }
            }

            /* HAP Specification 5.7.2.2
             If no error occurs, the accessory must send an HTTP response with a 204 No Content status code and an empty body.
             */
            return Response(status: .noContent)

        default:
            return .badRequest
        }
    }
}
