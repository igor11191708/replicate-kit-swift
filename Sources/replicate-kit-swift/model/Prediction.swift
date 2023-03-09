//
//  Prediction.swift
//  
// https://replicate.com/docs/reference/http
//  Created by Igor on 08.03.2023.
//

import Foundation

/// Result data of running a model with Input data
public struct Prediction<Output>: Decodable, Identifiable where Output: Decodable{
    
    /// The unique ID of the prediction. Can be used to get a single prediction.
    public let id : String
    
    /// The unique ID of model version used to create the prediction
    public let version : String
    
    /// Indicates where the prediction was created. Possible values are web or api
    public let source : String?
    
    /// Status of the prediction. Refer to get a single prediction for possible values.
    public let status : Status
    
    /// Errors
    public let error: String?
    
    /// Metrics object with a **predict_time** property showing the amount of CPU or GPU time, in seconds, that this prediction used while running.
    public let metrics: Metrics?
    
    /// Result of prediction
    /// Input and output (including any files) are automatically deleted after an hour, so you must save a copy of any files in the output if you'd like to continue using them.
    public let output: Output?
}


public extension Prediction{
    
    /// https://replicate.com/docs/reference/http#get-prediction
    enum Status: String, Hashable, Codable{
        /// the prediction is starting up. If this status lasts longer than a few seconds, then it's typically because a new worker is being started to run the prediction
        case starting
        /// the predict() method of the model is currently running.
        case processing
        ///  the prediction completed successfully
        case succeeded
        /// the prediction encountered an error during processing
        case failed
        /// the prediction was canceled by the user
        case canceled
        
        /// Check is prediction process was terminated
        public var isTerminated: Bool {
            switch self {
            case .starting, .processing:
                return false
            default:
                return true
            }
        }
    }
    
    /// Metrics
    struct Metrics: Hashable, Codable {
        public let predict_time: Double?
    }
}
