//
//  SomeEncodable.swift
//  
//
//  Created by Igor on 10.03.2023.
//

import Foundation

public struct SomeEncodable: Encodable, IEncodable, IHashable{

    public typealias ValueType = Self
    
    public let value: Any
    
    public init<T>(_ value: T?) {
        
        self.value = value ?? ()
        
    }
}
/// A type that can be compared for value equality.
extension SomeEncodable: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    public static func == (lhs: SomeEncodable, rhs: SomeEncodable) -> Bool {
        
        switch (lhs.value, rhs.value) {
            
            case is (Void, Void): return true
            
            case let (lhs as String, rhs as String):return lhs == rhs
            
            case let (lhs as Bool, rhs as Bool): return lhs == rhs
            
            case let (lhs as Int, rhs as Int): return lhs == rhs
            case let (lhs as UInt, rhs as UInt): return lhs == rhs

            case let (lhs as Double, rhs as Double): return lhs == rhs
            case let (lhs as Float, rhs as Float): return lhs == rhs

                
            case let (lhs as Date, rhs as Date):return lhs == rhs
            case let (lhs as URL, rhs as URL):return lhs == rhs
                
            case let (lhs as [SomeEncodable], rhs as [SomeEncodable]): return lhs == rhs
            case let (lhs as [String: SomeEncodable], rhs as [String: SomeEncodable]): return lhs == rhs
            
            default: return false
        }
        
    }
}

///    let dic : [SomeEncodable] = [
///       1, "Name", "Age", true, 6.56, "ñ", nil
///    ]
///    
/// A type that can be initialized using the nil literal, nil.
extension SomeEncodable: ExpressibleByNilLiteral {
    /// Creates an instance initialized with nil .
    public init(nilLiteral _: ()) {
        self.init(nil as Any?)
    }
}
/// A type that can be initialized with a string literal.
extension SomeEncodable: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// A type that can be initialized by string interpolation with a string literal that includes expressions.
extension SomeEncodable: ExpressibleByStringInterpolation {
    /// Creates a character with the specified value.
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
}

/// A type that can be initialized with an integer literal.
extension SomeEncodable: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

///A type that can be initialized with the Boolean literals true and false.
extension SomeEncodable: ExpressibleByBooleanLiteral {
    /// Creates an instance initialized to the specified Boolean literal.
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}

/// A type that can be initialized with a floating-point literal.
extension SomeEncodable: ExpressibleByFloatLiteral {
    /// Creates an instance initialized to the specified floating-point value.
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}
/// A type that can be initialized using an array literal.
extension SomeEncodable: ExpressibleByArrayLiteral {
    /// Creates an array from the given array literal.
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
}
/// A type that can be initialized using a dictionary literal.
///
extension SomeEncodable: ExpressibleByDictionaryLiteral {
    /// Creates a dictionary initialized with a dictionary literal.
    public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
        self.init([AnyHashable: Any](elements, uniquingKeysWith: { first, _ in first }))
    }
}
