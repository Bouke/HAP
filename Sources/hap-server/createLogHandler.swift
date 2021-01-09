import Foundation
import Logging


func createLogHandler(label: String) -> LogHandler {
    var handler = StreamLogHandler.standardOutput(label: label)
    #if DEBUG
        switch label {
        case "hap.encryption":
            handler.logLevel = .info
        case "hap": fallthrough
        case _ where label.starts(with: "hap."):
            handler.logLevel = .debug
        default:
            handler.logLevel = .info
        }
    #else
        switch label {
        case "bridge":
            handler.logLevel = .info
        default:
            handler.logLevel = .warning
        }
    #endif
    return handler
}
