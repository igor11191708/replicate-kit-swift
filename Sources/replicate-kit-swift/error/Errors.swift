//
//  Errors.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

extension ReplicateAPI{
    
    /// Set of replicate api errors
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum Errors : Error, Hashable{
                
        /// Base url error
        case baseURLError
        
        /// Timeout retry policy
        case timeout
        
        /// Prediction was terminated Check out ``Prediction.Status``
        case terminated
        
        /// Response error
        case responseError(ResponseError)
        
        /// Invalid response
        case invalidResponse(URLResponse, String?)
        
        /// Could not decode error format response
        case couldNotDecodeErrorContainer
    }    
}
