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
/// - Parameter error: Error
/// - Returns: Error with a decription why server cannot or will not process the request if it managed to parse data response, standard status error or nil if requst was succesful
internal func errorFn(status: Int,  _ response : URLResponse, data: Data?) -> Error?{
    
    if (200...299).contains(status) { return nil }
    
    guard (400...499).contains(status) else{
        return Http.Errors.status(status, response, data)
    }
    
    guard let data = data else{
        return Http.Errors.status(status, response, data)
    }
    
    if let error = try? JSONDecoder().decode(ResponseError.self, from: data){
        return error
    }
    
    return Http.Errors.status(status, response, data)
    
}
