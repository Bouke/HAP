import Foundation
import HKDF
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.endpoints.characteristics")

// swiftlint:disable:next cyclomatic_complexity
func characteristics(device: Device) -> Application {
    return { connection, request in
        switch request.method {
        case "GET":
            guard
                let queryItems = request.urlComponents.queryItems,
                let query = try? Protocol.GetQuery(queryItems: queryItems)
            else {
                return .badRequest
            }

            var responses = [Protocol.Characteristic]()
            for path in query.paths {
                // TODO: change api to do something like this:
                //     device.accessories[path.aid].characteristics[path.iid]
                // or maybe:
                //     device.characteristics[path]
                guard let accessory = device.accessories.first(where: { $0.aid == path.aid }),
                    // swiftlint:disable:next line_length
                    let characteristic = accessory.services.flatMap({ $0.characteristics.filter({ $0.iid == path.iid }) }).first
                    else {
                        responses.append(Protocol.Characteristic(aid: path.aid,
                                                                 iid: path.iid,
                                                                 status: .resourceDoesNotExist))
                        continue
                }
                guard characteristic.permissions.contains(.read) else {
                    logger.info("\(characteristic) has no read permission")
                    responses.append(Protocol.Characteristic(aid: path.aid, iid: path.iid, status: .writeOnly))
                    continue
                }
                guard accessory.reachable else {
                    responses.append(Protocol.Characteristic(aid: path.aid,
                                                             iid: path.iid,
                                                             status: .unableToCommunicate))
                    continue
                }

                var value: Protocol.Value?
                switch characteristic.getValue() {
                case let _value as Double: value = .double(_value)
                case let _value as Float: value = .double(Double(_value))
                case let _value as Int: value = .int(_value)
                case let _value as Bool: value = .int(_value ? 1 : 0)
                case let _value as String: value = .string(_value)
                default: value = nil
                }

                var response = Protocol.Characteristic(aid: path.aid, iid: path.iid, value: value)
                if query.meta {
                    response.maxValue = characteristic.maxValue
                    response.minValue = characteristic.minValue
                    response.unit = characteristic.unit
                    response.minStep = characteristic.minStep
                    response.maxLen = characteristic.maxLength
                }
                if query.perms {
                    response.perms = characteristic.permissions
                }
                if query.type {
                    response.type = characteristic.type
                }
                if query.ev {
                    response.ev = characteristic.permissions.contains(.events)
                }
                responses.append(response)
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
            if !responses.filter({ $0.status != nil }).isEmpty {
                for index in responses.indices where responses[index].status == nil {
                    responses[index].status = .success
                }
                responseStatus = .multiStatus
            }

            do {
                let json = try JSONEncoder().encode(Protocol.CharacteristicContainer(characteristics: responses))
                return Response(status: responseStatus, data: json, mimeType: "application/hap+json")
            } catch {
                logger.error("Could not serialize object", error: error)
                return .internalServerError
            }

        case "PUT":
            var body = Data()
            let bytesRead = try? request.readAllData(into: &body)
            logger.debug("PUT data: \(String(bytes: body, encoding: .utf8))")
            guard bytesRead != nil,
                let decoded = try? JSONDecoder().decode(Protocol.CharacteristicContainer.self, from: body)
            else {
                    logger.warning("Could not decode JSON")
                    return .badRequest
            }
            var statuses = [Protocol.Characteristic]()
            for item in decoded.characteristics {
                var status = Protocol.Characteristic(aid: item.aid, iid: item.iid)
                guard let accessory = device.accessories.first(where: { $0.aid == item.aid }),
                    let characteristic = accessory
                        .services
                        .flatMap({ $0.characteristics.filter({ $0.iid == item.iid }) })
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
                    guard accessory.reachable else {
                        status.status = .unableToCommunicate
                        break VALUE  // continue and process other items
                    }

                    logger.debug("Setting \(characteristic) to new value \(value) (type: \(type(of: value)))")
                    do {
                        switch value {
                        case let .string(value):
                            try characteristic.setValue(value, fromConnection: connection)
                        case let .int(int):
                            try characteristic.setValue(int, fromConnection: connection)
                        case let .double(double):
                            try characteristic.setValue(double, fromConnection: connection)
                        case let .bool(bool):
                            try characteristic.setValue(bool, fromConnection: connection)
                        }
                        status.status = .success
                    } catch {
                        logger.warning("Could not set value of type \(type(of: value)): \(error)")
                        status.status = .invalidValue
                       break VALUE
                    }

                    // notify listeners
                    device.notifyListeners(of: characteristic, exceptListener: connection)
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
                    return Response(status: statuses.count == 1 ? .badRequest : .multiStatus,
                                    data: json,
                                    mimeType: "application/hap+json")
                } catch {
                    logger.error("Could not serialize object", error: error)
                    return .internalServerError
                }
            }

            /* HAP Specification 5.7.2.2
             If no error occurs, the accessory must send an HTTP response with
             a 204 No Content status code and an empty body.
             */
            return Response(status: .noContent)

        default:
            return .badRequest
        }
    }
}
