//
//  SmartDecodingError.swift
//  SmartCodable
//
//  Created by qixin on 2024/2/27.
//

import Foundation



extension DecodingError {
    struct Keyed {
        static func _keyNotFound(key: CodingKey, codingPath: [CodingKey]) -> DecodingError {
            DecodingError.keyNotFound(key, DecodingError.Context(codingPath: codingPath, debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
        }
        
        static func _valueNotFound(key: CodingKey, expectation: Any.Type, codingPath: [CodingKey]) -> DecodingError {
            DecodingError.valueNotFound(expectation, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(expectation) value but found null instead."))
        }
    }
    
    struct UnKeyed {
        
    }
    
    struct Nested {
        static func keyNotFound<Key: CodingKey>(_ key: Key, codingPath: [CodingKey], isUnkeyed: Bool = false) -> DecodingError {
            let debugDescription = isUnkeyed
                ? "Cannot get UnkeyedDecodingContainer -- no value found for key \("\(key) (\"\(key.stringValue)\")")"
                : "Cannot get \(KeyedDecodingContainer<Key>.self) -- no value found for key \("\(key) (\"\(key.stringValue)\")")"
            return DecodingError.keyNotFound(
                key,
                DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: debugDescription
                )
            )
        }
    }
}



extension DecodingError {
    /// Returns a `.typeMismatch` error describing the expected type.
    ///
    /// - parameter path: The path of `CodingKey`s taken to decode a value of this type.
    /// - parameter expectation: The type expected to be encountered.
    /// - parameter reality: The value that was encountered instead of the expected type.
    /// - returns: A `DecodingError` with the appropriate path and debug description.
    static func _typeMismatch(at path: [CodingKey], expectation: Any.Type, reality: Any?) -> DecodingError {
        let description = "Expected to decode \(expectation) but found \(_typeDescription(of: reality)) instead."
        return .typeMismatch(expectation, Context(codingPath: path, debugDescription: description))
    }
    
    /// Returns a description of the type of `value` appropriate for an error message.
    ///
    /// - parameter value: The value whose type to describe.
    /// - returns: A string describing `value`.
    /// - precondition: `value` is one of the types below.
    private static func _typeDescription(of value: Any?) -> String {
        if value is NSNull {
            return "a null value"
        } else if value is NSNumber /* FIXME: If swift-corelibs-foundation isn't updated to use NSNumber, this check will be necessary: || value is Int || value is Double */ {
            return "a number"
        } else if value is String {
            return "a string/data"
        } else if value is [Any] {
            return "an array"
        } else if value is [String : Any] {
            return "a dictionary"
        } else {
            return "\(type(of: value))"
        }
    }
}