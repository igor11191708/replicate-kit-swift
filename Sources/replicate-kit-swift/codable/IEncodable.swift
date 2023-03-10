//
//  IEncodable.swift
//  
//
//  Created by Igor on 10.03.2023.
//

import Foundation

/// A type that can encode itself to an external representation from different types.
public protocol IEncodable {
        
    /// wrapped value
    var value: Any { get }
    
    init<T>(_ value: T?)
    
}

public extension IEncodable{
    
    /// Encodes the output from upstream using a specified encoder.
    func encode(to encoder: Encoder) throws {
        /// Returns the data stored in this decoder as represented in a container appropriate for holding a single primitive value.
        var container = encoder.singleValueContainer()
        
        switch value {
            /// let empty : SomeEncodable = nil
            case is Void: try container.encodeNil()
                
            case let string as String: try container.encode(string)
                
            case let bool as Bool: try container.encode(bool)
                
            case let int as Int: try container.encode(int)
            case let uInt as UInt: try container.encode(uInt)
                
            case let double as Double: try container.encode(double)

            /// let date : SomeEncodable = .init(Date())
            case let date as Date: try container.encode(date.ISO8601Format())
            
            /// let date : SomeEncodable = .init(URL(string: "https://www.google.com/"))
            case let url as URL: try container.encode(url)
                
///            let dic : [SomeEncodable] = [
///                1, "Name", "Age", true, 6.56, nil
///            ]
            case let array as [Any?]: try container.encode(array.map { SomeEncodable($0) })
              
///            let dic : [String: SomeEncodable] = [
///                "id" : 1,
///                "data" : nil
///            ]
            case let dictionary as [String: Any?]: try container.encode(dictionary.mapValues { SomeEncodable($0) })
            
///            struct User: Encodable{
///                let name: String
///            }
///            let dic : [String: SomeEncodable] = [
///                "data" : .init(User(name: "test"))
///            ]
            
            case let encodable as Encodable: try encodable.encode(to: encoder)
            
            default:
                let ctx = EncodingError.Context(codingPath: container.codingPath, debugDescription: "Can't encode value")
                throw EncodingError.invalidValue(value, ctx)
            }
    }
}

    

    

    

    

    
