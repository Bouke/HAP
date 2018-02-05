import Foundation

extension String {
    func padLeft (toLength: Int, withPad: String) -> String {
        let toPad = toLength - self.count
        if toPad < 1 {
            return self
        }
        return "".padding(toLength: toPad, withPad: withPad, startingAt: 0) + self
    }
}
