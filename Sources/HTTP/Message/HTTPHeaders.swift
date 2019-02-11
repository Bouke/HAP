extension HTTPHeaders {
    /// Add a header name/value pair to the block.
    ///
    /// This method is strictly additive: if there are other values for the given header name
    /// already in the block, this will add a new entry. `add` performs case-insensitive
    /// comparisons on the header field name.
    ///
    /// - Parameter name: The header field name. For maximum compatibility this should be an
    ///     ASCII string. For future-proofing with HTTP/2 lowercase header names are strongly
    //      recommended.
    /// - Parameter value: The header field value to add for the given name.
    public mutating func add(name: HTTPHeaderName, value: String) {
        add(name: name.lowercased, value: value)
    }

    /// Add a header name/value pair to the block, replacing any previous values for the
    /// same header name that are already in the block.
    ///
    /// This is a supplemental method to `add` that essentially combines `remove` and `add`
    /// in a single function. It can be used to ensure that a header block is in a
    /// well-defined form without having to check whether the value was previously there.
    /// Like `add`, this method performs case-insensitive comparisons of the header field
    /// names.
    ///
    /// - Parameter name: The header field name. For maximum compatibility this should be an
    ///     ASCII string. For future-proofing with HTTP/2 lowercase header names are strongly
    //      recommended.
    /// - Parameter value: The header field value to add for the given name.
    public mutating func replaceOrAdd(name: HTTPHeaderName, value: String) {
        replaceOrAdd(name: name.lowercased, value: value)
    }

    /// Remove all values for a given header name from the block.
    ///
    /// This method uses case-insensitive comparisons for the header field name.
    ///
    /// - Parameter name: The name of the header field to remove from the block.
    public mutating func remove(name: HTTPHeaderName) {
        remove(name: name.lowercased)
    }

    /// Retrieve all of the values for a given header field name from the block.
    ///
    /// This method uses case-insensitive comparisons for the header field name. It
    /// does not return a maximally-decomposed list of the header fields, but instead
    /// returns them in their original representation: that means that a comma-separated
    /// header field list may contain more than one entry, some of which contain commas
    /// and some do not. If you want a representation of the header fields suitable for
    /// performing computation on, consider `getCanonicalForm`.
    ///
    /// - Parameter name: The header field name whose values are to be retrieved.
    /// - Returns: A list of the values for that header field name.
    public subscript(name: HTTPHeaderName) -> [String] {
        return self[name.lowercased]
    }

    /// Returns `true` if the `HTTPHeaders` contains a value for the supplied name.
    /// - Parameter name: The header field name to check.
    public func contains(name: HTTPHeaderName) -> Bool {
        return self.contains(name: name.lowercased)
    }

    /// Returns the first header value with the supplied name.
    /// - Parameter name: The header field name whose values are to be retrieved.
    public func firstValue(name: HTTPHeaderName) -> String? {
        // fixme: optimize
        return self[name.lowercased].first
    }
}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {
    /// See `ExpressibleByDictionaryLiteral`
    public init(dictionaryLiteral elements: (String, String)...) {
        var headers = HTTPHeaders()
        for (key, val) in elements {
            headers.add(name: key, value: val)
        }
        self = headers
    }
}
extension HTTPHeaders: CustomDebugStringConvertible {
    /// See `CustomDebugStringConvertible.debugDescription`
    public var debugDescription: String {
        var desc: [String] = []
        for (key, val) in self {
            desc.append("\(key): \(val)")
        }
        return desc.joined(separator: "\n")
    }
}
