#if os(Linux) && !compiler(>=5.0)
import class Foundation.RunLoop
import struct Foundation.RunLoopMode

extension RunLoop {
    typealias Mode = RunLoopMode
}

extension RunLoopMode {
    static var `default`: RunLoopMode {
        return RunLoopMode.defaultRunLoopMode
    }
}
#endif
