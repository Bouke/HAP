//
//  Handler.swift
//  Evergreen
//
//  Created by Nils Fischer on 12.10.14.
//  Copyright (c) 2014 viWiD Webdesign & iOS Development. All rights reserved.
//

import Foundation


// MARK: - Record

public struct Record: CustomStringConvertible {

    public let date: Date
    public let logLevel: LogLevel?
    public let description: String

}


// MARK: - Handler

public class Handler {

    public var logLevel: LogLevel?
    public var formatter: Formatter

    public init(formatter: Formatter) {
        self.formatter = formatter
    }

    /// Called by a logger to handle an event. The event's log level is checked against the handler's and the given formatter is used to obtain a record from the event. Subsequently, `emitRecord` is called to produce the output.
    public final func emitEvent<M>(_ event: Event<M>) {
        if let handlerLogLevel = self.logLevel,
            let eventLogLevel = event.logLevel,
            eventLogLevel < handlerLogLevel {
            return
        }
        self.emitRecord(self.formatter.recordFromEvent(event))
    }

    /// Called to actually produce some output from a record. Override this method to send the record to an output stream of your choice. The default implementation simply prints the record to the console.
    public func emitRecord(_ record: Record) {
        print(record)
    }

}


// MARK: - Console Handler Class

/// A handler that writes log records to the console.
public class ConsoleHandler: Handler {

    public convenience init() {
        self.init(formatter: Formatter(style: .default))
    }

    override public func emitRecord(_ record: Record) {
        // TODO: use debugPrintln?
        print(record)
    }

}


// MARK: - File Handler Class

/// A handler that writes log records to a file.
public class FileHandler: Handler, CustomStringConvertible {

    private var file: FileHandle!
    private let fileURL: URL

    public convenience init?(fileURL: URL) {
        self.init(fileURL: fileURL, formatter: Formatter(style: .full))
    }

    public init?(fileURL: URL, formatter: Formatter) {
        self.fileURL = fileURL
        super.init(formatter: formatter)
        let fileManager = FileManager.default
        guard let path = (fileURL as NSURL).filePathURL?.path else {
            return nil
        }
        guard fileManager.createFile(atPath: path, contents: nil, attributes: nil) else {
            return nil
        }
        guard let file = FileHandle(forWritingAtPath: path) else {
            return nil
        }
        file.seekToEndOfFile()
        self.file = file
    }

    override public func emitRecord(_ record: Record) {
        if let recordData = (record.description + "\n").data(using: String.Encoding.utf8, allowLossyConversion: true) {
            self.file.write(recordData)
        } else {
            // TODO
        }
    }

    public var description: String {
        return "FileHandler(\(fileURL))"
    }

}


// MARK: Stenography Handler

/// A handler that appends log records to an array.
public class StenographyHandler: Handler {

    // TODO: make sure there is no memory problem when this array becomes too large
    /// All records logged to this handler
    public private(set) var records: [Record] = []

    public convenience init() {
        self.init(formatter: Formatter(style: .default))
    }

    override public func emitRecord(_ record: Record) {
        self.records.append(record)
    }
    
}
