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
    public enum Errors : Error{
                
        /// Base url errror
        case baseURLError
        
        /// Timeout retry policy
        case timeout
        
        /// Prediction was terminated Check out ``Prediction.Status``
        case terminated
    }    
}
