//
//  IEndpoint.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation
/// Define end points for Replicate API
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol IEndpoint{
    
    static var baseURL: String { get }
    
}
