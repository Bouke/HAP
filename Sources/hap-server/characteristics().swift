import Foundation
import HTTP
import HKDF
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap")

func characteristics(connection: Connection, request: Request) -> Response {
    switch request.method {
    case .GET?:
        guard let URL = request.URL, let components = URLComponents(url: URL, resolvingAgainstBaseURL: false), let id = components.queryItems?.first(where: {$0.name == "id"})?.value else {
            return .badRequest
        }

        let paths = id.components(separatedBy: ",").map { $0.components(separatedBy: ".").flatMap { Int($0) } }

        var serialized: [[String: AnyObject]] = []
        for path in paths {
            guard path.count == 2 else {
                return .badRequest
            }
            guard let characteristic = device.accessories.first(where: {$0.id == path[0]})?.services.flatMap({$0.characteristics.filter({$0.id == path[1]})}).first else {
                // @fixme: hc sets status to StatusServiceCommunicationFailure instead
                return .notFound
            }
            serialized.append([
                "aid": path[0] as AnyObject,
                "iid": path[1] as AnyObject,
                "value": characteristic.valueAsNSObject ?? NSNull()
            ])
        }

        let json = try! JSONSerialization.data(withJSONObject: ["characteristics": serialized], options: [])
        return Response(data: json, mimeType: "application/hap+json")

    case .PUT?:
        guard let body = request.body, let deserialized = try? JSONSerialization.jsonObject(with: body, options: []), let dict = deserialized as? [String: [[String: AnyObject]]], let items = dict["characteristics"] else {
            return .badRequest
        }

        for item in items {
            guard let aid = (item["aid"] as? NSNumber).flatMap({$0.intValue}), let iid = (item["iid"] as? NSNumber).flatMap({$0.intValue}) else {
                return .badRequest
            }
            guard let characteristic = device.accessories.first(where: {$0.id == aid})?.services.flatMap({$0.characteristics.filter({$0.id == iid})}).first else {
                return .notFound
            }

            // set new value
            if let value = item["value"] {
                do {
                    switch value {
                    case let value as NSNumber: try characteristic.setValue(fromNSObject: value)
                    case let value as NSString: try characteristic.setValue(fromNSObject: value)
                    case is NSNull: try characteristic.setValue(fromNSObject: nil)
                    default: return .badRequest
                    }
                } catch {
                    return .badRequest
                }

                // notify listeners
                let serialized: [String: [[String: AnyObject]]] = ["characteristics": [
                    [
                        "aid": aid as AnyObject,
                        "iid": iid as AnyObject,
                        "value": characteristic.valueAsNSObject ?? NSNull()
                    ]
                ]]
                guard let body = try? JSONSerialization.data(withJSONObject: serialized, options: []) else {
                    abort()
                }
                let event = Event(status: .ok, body: body, mimeType: "application/hap+json")
                device.notify(characteristicListeners: characteristic, event: event, exceptListener: connection)
            }

            // toggle events for this characteristic on this connection
            if let events = (item["ev"] as? NSNumber).flatMap({$0.boolValue}) {
                if events {
                    device.add(characteristic: characteristic, listener: connection)
                    logger.info("Added listener for \(characteristic)")
                } else {
                    device.remove(characteristic: characteristic, listener: connection)
                    logger.info("Removed listener for \(characteristic)")
                }
            }
        }

        return Response(status: .noContent)

    default:
        return .badRequest
    }
}
