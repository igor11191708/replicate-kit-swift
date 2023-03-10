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
        
        /// An HTTPS URL for receiving a webhook when the prediction has new output. The webhook will be a POST request where the request body is the same as the response body of the get prediction operation. If there are network problems, we will retry the webhook a few times, so make sure it can be safely called more than once.
        let webhook: URL?
    }
}
