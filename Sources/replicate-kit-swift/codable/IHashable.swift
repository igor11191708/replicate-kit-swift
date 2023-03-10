//
//  IHashable.swift
//  
//
//  Created by Igor on 10.03.2023.
//

import Foundation


protocol IHashable: Hashable{
    
    associatedtype ValueType: Hashable
    
    var value: Any { get }

}

extension IHashable{
    /// Hashes the essential components of this value by feeding them into the given hasher.
    public func hash(into hasher: inout Hasher) {
        
        switch value {
            /// Type 'Void' cannot conform to 'Hashable'
            
            case _ as Void: hasher.combine(NSNull())
            
            case let value as String: hasher.combine(value)
            
            case let value as Bool: hasher.combine(value)
            
            case let value as Int: hasher.combine(value)
            case let value as UInt: hasher.combine(value)
            
            case let value as Float: hasher.combine(value)
            case let value as Double: hasher.combine(value)
            
            case let value as Date: hasher.combine(value)
            
            case let value as URL: hasher.combine(value)

            case let value as [String: ValueType]: hasher.combine(value)
            case let value as [ValueType]:hasher.combine(value)
            
            default: break
        }
    }
}
