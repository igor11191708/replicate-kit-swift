//
//  HttpBody.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation


extension ReplicateAPI{
    
    /// Http request body
    struct HttpBody<Input>: Encodable where Input : Encodable{
        
        /// Model vertion
        let version : String
        
        /// Input data
        let input : Input
    }
}
