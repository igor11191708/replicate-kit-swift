//
//  ResponseError.swift
//  
//
//  Created by Igor on 11.03.2023.
//

import Foundation

/// Error format : "{\"detail\":\"Incorrect authentication token. Learn how to authenticate and get your API token here: https://replicate.com/docs/reference/http#authentication\"}"
public struct ResponseError: Hashable, CustomStringConvertible, LocalizedError, Decodable{
    
    public let detail: String
    
    /// CustomStringConvertible
    public var description: String {
        return detail
    }
    
    /// LocalizedError
    public var errorDescription: String? {
        return detail
    }
    
    private enum CodingKeys: String, CodingKey {
        case detail
    }

    public init(from decoder: Decoder) throws {
        
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            detail = try container.decode(String.self, forKey: .detail)
        }else {
            let ctx = DecodingError.Context(
                codingPath: [CodingKeys.detail],
                debugDescription: "could not to decode error response")
            
            throw DecodingError.dataCorrupted(ctx)
        }
    }
    
}
