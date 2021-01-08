import Foundation
import Logging


func createLogHandler(label: String) -> LogHandler {
    var handler = StreamLogHandler.standardOutput(label: label)
    #if DEBUG
        print("DEBUG")
        switch label {
        case "hap.encryption":
            handler.logLevel = .info
        case _ where label.starts(with: "hap"):
            handler.logLevel = .debug
        default:
            handler.logLevel = .info
        }
    #else
        // No logging
        handler.logLevel = .critical
    #endif
    return handler
}
