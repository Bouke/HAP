// swiftlint:disable all
import COperatingSystem
import Foundation
import NIO

/// An internal helper that formats cookie dates as RFC1123
private final class RFC1123 {
    /// Thread-specific RFC1123
    private static let thread: ThreadSpecificVariable<RFC1123> = .init()

    /// A static RFC1123 helper instance
    static var shared: RFC1123 {
        if let existing = thread.currentValue {
            return existing
        } else {
            let new = RFC1123()
            thread.currentValue = new
            return new
        }
    }

    /// The RFC1123 formatter
    private let formatter: DateFormatter

    /// Creates a new RFC1123 helper
    private init() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        self.formatter = formatter
    }

    func string(from date: Date) -> String {
        return formatter.string(from: date)
    }

    func date(from string: String) -> Date? {
        return formatter.date(from: string)
    }
}

extension Date {
    /// Formats a `Date` as RFC1123
    public var rfc1123: String {
        return RFC1123.shared.string(from: self)
    }

    /// Creates a `Date` from an RFC1123 string
    public init?(rfc1123: String) {
        guard let date = RFC1123.shared.date(from: rfc1123) else {
            return nil
        }

        self = date
    }
}

/// Performant method for generating RFC1123 date headers.
internal final class RFC1123DateCache {
    /// Thread-specific RFC1123
    private static let thread: ThreadSpecificVariable<RFC1123DateCache> = .init()

    /// A static RFC1123 helper instance
    public static var shared: RFC1123DateCache {
        if let existing = thread.currentValue {
            return existing
        } else {
            let new = RFC1123DateCache()
            thread.currentValue = new
            return new
        }
    }

    /// Currently cached time components.
    private var cachedTimeComponents: (key: time_t, components: COperatingSystem.tm)?

    /// Currently cached timestamp.
    private var cachedTimestamp: (timestamp: String, expiration: Int)?

    /// Creates a new `RFC1123DateCache`.
    private init() { }

    /// Gets the current RFC 1123 date string.
    func currentTimestamp() -> String {
        // get the current time
        var date = COperatingSystem.time(nil)

        // check if the cached timestamp is still valid
        if let (timestamp, expiration) = cachedTimestamp, date < expiration {
            return timestamp
        }

        // generate a key used for caching
        // this key is a unique id for each day
        let key = date / secondsInDay

        // get time components
        let dateComponents: tm
        if let cached = cachedTimeComponents, cached.key == key {
            dateComponents = cached.components
        } else {
            var tc = tm.init()
            gmtime_r(&date, &tc)
            dateComponents = tc
            cachedTimeComponents = (key: key, components: tc)
        }

        // parse components
        let year: Int = numericCast(dateComponents.tm_year) + 1900 // years since 1900
        let month: Int = numericCast(dateComponents.tm_mon) // months since January [0-11]
        let monthDay: Int = numericCast(dateComponents.tm_mday) // day of the month [1-31]
        let weekDay: Int = numericCast(dateComponents.tm_wday) // days since Sunday [0-6]

        // get basic time info
        let time: Int = date % secondsInDay
        let hours: Int = numericCast(time / 3600)
        let minutes: Int = numericCast((time / 60) % 60)
        let seconds: Int = numericCast(time % 60)

        // generate the RFC 1123 formatted string
        var rfc1123 = ""
        rfc1123.reserveCapacity(30)
        rfc1123.append(dayNames[weekDay])
        rfc1123.append(", ")
        rfc1123.append(stringNumbers[monthDay])
        rfc1123.append(" ")
        rfc1123.append(monthNames[month])
        rfc1123.append(" ")
        rfc1123.append(stringNumbers[year / 100])
        rfc1123.append(stringNumbers[year % 100])
        rfc1123.append(" ")
        rfc1123.append(stringNumbers[hours])
        rfc1123.append(":")
        rfc1123.append(stringNumbers[minutes])
        rfc1123.append(":")
        rfc1123.append(stringNumbers[seconds])
        rfc1123.append(" GMT")

        // cache the new timestamp and its expiration
        cachedTimestamp = (rfc1123, date + accuracy)

        return rfc1123
    }
}

// MARK: Private

private let dayNames = [
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
]

private let monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
]

private let stringNumbers = [
    "00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
    "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
    "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
    "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
    "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
    "50", "51", "52", "53", "54", "55", "56", "57", "58", "59",
    "60", "61", "62", "63", "64", "65", "66", "67", "68", "69",
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
    "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"
]

private let secondsInDay = 60 * 60 * 24
private let accuracy: Int = 1 // seconds
