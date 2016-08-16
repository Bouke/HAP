//
//  Formatter.swift
//  Evergreen
//
//  Created by Nils Fischer on 12.10.14.
//  Copyright (c) 2014 viWiD Webdesign & iOS Development. All rights reserved.
//

import Foundation


public class Formatter {

    public let components: [Component]

    public init(components: [Component]) {
        self.components = components
    }

    public enum Style {
        case `default`, simple, full
    }

    /// Creates a formatter from any of the predefined styles.
    public convenience init(style: Style) {
        let components: [Component]
        switch style {
        case .default:
            components = [ .text("["), .logger, .text("|"), .logLevel, .text("] "), .message ]
        case .simple:
            components = [ .message ]
        case .full:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            components = [ .date(formatter: dateFormatter), .text(" ["), .logger, .text("|"), .logLevel, .text("] "), .message ]
        }
        self.init(components: components)
    }

    public enum Component {
        case text(String), date(formatter: DateFormatter), logger, logLevel, message, function, file, line//, Any(stringForEvent: (event: Event<M>) -> String)

        public func stringForEvent<M>(_ event: Event<M>) -> String {
            switch self {
            case .text(let text):
                return text
            case .date(let formatter):
                return formatter.string(from: event.date as Date)
            case .logger:
                return event.logger.description
            case .logLevel:
                return (event.logLevel?.description ?? "Unspecified").uppercased()
            case .message:
                switch event.message() {
                case let error as NSError:
                    return error.localizedDescription
                case let message:
                    return String(describing: message)
                }
            case .function:
                return event.function
            case .file:
                return event.file
            case .line:
                return String(event.line)
            }
        }
    }

    /// Produces a record from a given event. The record can be subsequently emitted by a handler.
    public final func recordFromEvent<M>(_ event: Event<M>) -> Record {
        return Record(date: event.date, logLevel: event.logLevel, description: self.stringFromEvent(event))
    }

    public func stringFromEvent<M>(_ event: Event<M>) -> String
    {
        var string = components.map({ $0.stringForEvent(event) }).joined(separator: "")

        if let elapsedTime = event.elapsedTime {
            string += " [ELAPSED TIME: \(elapsedTime)s]"
        }

        if let error = event.error {
            let errorMessage: String
            switch error {
            case let error as CustomDebugStringConvertible:
                errorMessage = error.debugDescription
            case let error as CustomStringConvertible:
                errorMessage = error.description
            default:
                errorMessage = String(describing: error)
            }
            string += " [ERROR: \(errorMessage)]"
        }

        if event.once {
            string += " [ONLY LOGGED ONCE]"
        }

        return string
    }

}
