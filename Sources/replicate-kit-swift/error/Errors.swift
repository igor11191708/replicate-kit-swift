//
//  Errors.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

extension ReplicateAPI{
    
    /// Set of replicate API errors
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum Errors: Error, Hashable, LocalizedError {
                    
        /// Base URL error
        case baseURLError
        
        /// Timeout retry policy
        case timeout
        
        /// Prediction was terminated. Check out ``Prediction.Status``
        case terminated
        
        /// Response error
        case responseError(ResponseError)
        
        /// Invalid response
        case invalidResponse(URLResponse, String?)
        
        /// Could not decode error format response
        case couldNotDecodeErrorContainer

        /// Provides a localized description for each error case.
        public var errorDescription: String? {
            switch self {
            case .baseURLError:
                return NSLocalizedString("The base URL is invalid or missing.", comment: "Base URL error")
                
            case .timeout:
                return NSLocalizedString("The operation timed out. Please try again.", comment: "Timeout error")
                
            case .terminated:
                return NSLocalizedString("The prediction was terminated. Check its status for more details.", comment: "Prediction terminated")
                
            case .responseError(let responseError):
                return responseError.localizedDescription
                
            case .invalidResponse(_, let message):
                return message ?? NSLocalizedString("The response was invalid.", comment: "Invalid response")
                
            case .couldNotDecodeErrorContainer:
                return NSLocalizedString("Could not decode the error response. The format might be incorrect.", comment: "Decoding error")
            }
        }
    }
}
