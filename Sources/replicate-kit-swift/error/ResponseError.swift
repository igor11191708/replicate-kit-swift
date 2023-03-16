//
//  ResponseError.swift
//  
//
//  Created by Igor on 11.03.2023.
//

import Foundation
import async_http_client

/// Error format : "{\"detail\":\"Incorrect authentication token. Learn how to authenticate and get your API token here: https://replicate.com/docs/reference/http#authentication\"}"
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
        
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            throw ReplicateAPI.Errors.couldNotDecodeErrorContainer
        }
        
        do{
            detail = try container.decode(String.self, forKey: .detail)
        }catch{
            let ctx = DecodingError.Context(
                codingPath: [CodingKeys.detail],
                debugDescription: "Could not decode error response")
            
            throw DecodingError.dataCorrupted(ctx)
        }
    }
}

/// Processing cases server cannot or will not process the request due to something that is perceived to be a client error
/// 401 Unauthorized
/// 402 Payment Required
/// - Parameters:
///   - status: Status code
///   - response: URLResponse
///   - data: Received data
/// - Returns: Error with a description why server cannot or will not process the request if it managed to parse data response, standard status error or nil if request was successful
internal let errorFn : Http.Validate.Status.ErrorFn = {
    status, response, data -> Error? in
    
    /// Default error response if not valid status code and we can't decode error format response
    let error = Http.Errors.status(status, response, data)
    
    if (200...299).contains(status) { return nil }
    
    guard (400...499).contains(status) else{
        return error
    }
    
    guard let data = data else{
        return error
    }
    
    if let error = try? JSONDecoder().decode(ResponseError.self, from: data){
        return error
    }
    
    return error
}
