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

            let paths = id.components(separatedBy: ",").map { $0.components(separatedBy: ".").flatMap { Int($0) } }

            var serialized: [[String: Any]] = []
            for path in paths {
                guard path.count == 2 else {
                    return .badRequest
                }
                guard
                    let characteristic = device.accessories.first(where: {$0.aid == path[0]})?.services.flatMap({$0.characteristics.filter({$0.iid == path[1]})}).first
                    else {
                        // @fixme: hc sets status to StatusServiceCommunicationFailure instead
                        return .notFound
                }
                
                var body = ["aid": path[0],"iid": path[1],"value": characteristic.getValue() ?? NSNull()]
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
                
                serialized.append(body)
            }

            do {
                let json = try JSONSerialization.data(withJSONObject: ["characteristics": serialized], options: [])
                return Response(data: json, mimeType: "application/hap+json")
            } catch {
                logger.error("Could not serialize object", error: error)
                return .internalServerError
            }

        case "PUT":
            var body = Data()
            guard let _  = try? request.readAllData(into: &body),
                let deserialized = try? JSONSerialization.jsonObject(with: body, options: []),
                let dict = deserialized as? [String: [[String: Any]]],
                let items = dict["characteristics"] else
            {
                logger.warning("Could not decode JSON")
                return .badRequest
            }
            
            var serialized: [[String: Any]] = []
            var multiStatusResponse = false

            for item in items {
                guard let aid = item["aid"] as? Int,
                    let iid = item["iid"] as? Int else
                {
                    logger.warning("Missing either aid/iid keys")
                    return .badRequest
                }
                guard let characteristic = device.accessories
                    .first(where: {$0.aid == aid})?
                    .services
                    .flatMap({$0.characteristics.filter({$0.iid == iid})})
                    .first else
                {
                    return .invalidParameters
                }

                // set new value
                if let value = item["value"] {
                    guard characteristic.permissions.contains(.write) else {
                        logger.info("\(characteristic) has no write permission")
                        serialized.append(["aid": aid,"iid": iid,"status": HAPStatusCodes.readOnly.rawValue])
                        multiStatusResponse = true
                        break
                    }
                    
                    logger.debug("Setting \(characteristic) to new value \(value) (type: \(type(of: value)))")
                    do {
                        switch value {
                        case is NSNull:
                            try characteristic.setValue(nil, fromConnection: connection)
                        default:
                            try characteristic.setValue(value, fromConnection: connection)
                        }
                        serialized.append(["aid": aid,"iid": iid,"status": 0])

                    } catch {
                        logger.warning("Could not set value of type \(type(of: value)): \(error)")
                        return .badRequest
                    }

                    // notify listeners
                    device.notify(characteristicListeners: characteristic, exceptListener: connection)
                }

                // toggle events for this characteristic on this connection
                if let events = item["ev"] as? Bool {
                    if events {
                        device.add(characteristic: characteristic, listener: connection)
                        logger.info("Added listener for \(characteristic)")
                    } else {
                        device.remove(characteristic: characteristic, listener: connection)
                        logger.info("Removed listener for \(characteristic)")
                    }
                }
            }
            
            if multiStatusResponse {
                do {
                    let json = try JSONSerialization.data(withJSONObject: ["characteristics": serialized], options: [])
                    return Response(status: serialized.count == 1 ? .badRequest : .multiStatus, data: json, mimeType: "application/hap+json")
                } catch {
                    logger.error("Could not serialize object", error: error)
                    return .internalServerError
                }
            }


            return Response(status: .noContent)

        default:
            return .badRequest
        }
    }
}
