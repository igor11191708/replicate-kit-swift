//
//  Expect.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation
import retry_policy_service


extension ReplicateAPI{
    
    /// Strategy for getting result after launching a prediction creation
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public enum Expect{
        
        /// Do not expect the result, just create a prediction
        case none
        
        /// Expect the result with retry policy
        case yes(RetryService.Strategy = .constant(
            retry: UInt.max,
            duration: .seconds(2),
            timeout: .seconds(60)
        ))
    }
}
