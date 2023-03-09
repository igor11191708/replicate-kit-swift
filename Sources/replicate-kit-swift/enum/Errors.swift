//
//  Errors.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

extension ReplicateAPI{
    
    /// Set of replicate api errors
    public enum Errors : Error{
                
        /// Base url errror
        case baseURLError
        
        /// Timeout retry policy
        case timeout
        
        /// Prediction was terminated Check out ``Prediction.Status``
        case terminated
    }
    
}
