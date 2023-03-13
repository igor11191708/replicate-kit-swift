//
//  ReplicateAPI.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation
import async_http_client
import retry_policy_service

/// HTTP API reference
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ReplicateAPI{
    
    /// Client type alias
    public typealias ReplicateClient = Http.Proxy<ReplicateAPI.JsonReader,JsonWriter>
    
    /// Communication layer
    private let client : ReplicateClient
        
    // MARK: - Life circle
    
    /// Init with custom client and endpoint
    /// - Parameters:
    ///   - client: Custom client
    ///   - endpoint: Replicate endpoint
    ///   - apiKey: Api key
    public init(
        client: ReplicateClient.Type,
        endpoint : IEndpoint.Type,
        apiKey : String
    ) throws {
        
        guard let url = URL(string: endpoint.baseURL) else{
            throw Errors.baseURLError
        }
        
        let cfg = clientCfg(baseURL: url, apiKey: apiKey)
        self.client = client.init(config: cfg)
    }
    
    /// Init with endpoint
    /// - Parameter endpoint: Replicate endpoint
    ///   - apiKey: Api key
    public init(
        endpoint : IEndpoint.Type,
        apiKey : String
    ) throws {
        
        guard let url = URL(string: endpoint.baseURL) else{
            throw Errors.baseURLError
        }
        
        let cfg = clientCfg(baseURL: url, apiKey: apiKey)
        self.client = Http.Proxy.init(config: cfg)
    }
   
    /// - Parameters:
    ///   - baseURL: Base url ``ReplicateAPI.Endpoint`` or currently "https://api.replicate.com/v1/"
    ///   - apiKey: Api key
    public init(
        baseURL: URL,
        apiKey : String
    ) {
        let cfg = clientCfg(baseURL: baseURL, apiKey: apiKey)
        self.client = Http.Proxy.init(config: cfg)
    }
    
    // MARK: - API
    
    /// Get a collection of models
    /// - Parameter collection_slug: The slug of the collection, like super-resolution or image-restoration
    /// - Returns: a collection of models
    public func getCollections(collection_slug : String) async throws -> CollectionOfModels{
        
        let path = "collections/\(collection_slug)"
        let rule = [Http.Validate.status(.range(200..<500))]
        let result : Http.Response<CollectionOfModels> = try await client.get(path: path, validate: rule)
        
        return result.value
    }
    
    /// Get a model
    /// - Parameters:
    ///   - owner: Model owner
    ///   - name: Model name
    public func getModel(owner: String, name: String) async throws -> Model{
        
        let path = "models/\(owner)/\(name)"
        let rule = [Http.Validate.status(.range(200..<500))]
        let result : Http.Response<Model> = try await client.get(path: path, validate: rule)
        
        return result.value
    }
    
    /// Create prediction
    /// https://replicate.com/docs/reference/http#create-prediction
    /// - Parameters:
    ///   - versionId: Version id
    ///   - input: Input data
    ///   - expect: Logic for creating a prediction Check out ``ReplicateAPI.Expect``
    ///  - webhook: An HTTPS URL for receiving a webhook when the prediction has new output.
    /// - Returns: Prediction result
    public func createPrediction<Input: Encodable, Output: Decodable>(
        version id : String,
        input: Input,
        expect: Expect = .yes(),
        webhook: URL? = nil
    ) async throws -> Prediction<Output>{
        
        typealias Result = Prediction<Output>
        
        let body = HttpBody(version: id, input: input, webhook: webhook)
        
        #if DEBUG
        if let data = try? JSONEncoder().encode(body){
            print(String(decoding: data, as: UTF8.self))
        }
        #endif
        
        let prediction: Result = try await launchPrediction(with: body)
        
        guard case let .yes(strategy) = expect else { return prediction }
    
        let id = prediction.id
        
        do{
           return try await retry(with: id, retry: strategy)
        }catch{
            return prediction
        }
    }
    
    /// Returns the same response as the create a prediction operation
    /// status will be one of ``Prediction.Status``
    /// In the case of success, output will be an object containing the output of the model. Any files will be represented as URLs. You'll need to pass the Authorization header to request them.
    /// - Parameter id: Prediction id
    /// - Returns: Prediction
    public func getPrediction<Output: Decodable>(
        by id : String
    ) async throws -> Prediction<Output>{
            
        let rule = [Http.Validate.status(.range(200..<500))]
        let result : Http.Response<Prediction<Output>> = try await client.get(
            path: "predictions/\(id)",
            validate: rule
        )
                        
        return result.value
    }

    // MARK: - Private
    
    /// poll the get a prediction endpoint until it has one of the statuses
    /// - Parameters:
    ///   - id: Prediction id
    ///   - strategy: Retry strategy
    /// - Returns: Prediction
    private func retry<Output: Decodable>(
        with id : String,
        retry strategy : RetryService.Strategy
    ) async throws -> Prediction<Output>{
        
        typealias Result = Prediction<Output>
        
        let policy = RetryService(strategy: strategy)
       
        for delay in policy{ // until timeout or succeeded
           
            try await Task.sleep(nanoseconds: delay)
            
            let prediction: Result = try await getPrediction(by: id)

            let status = prediction.status
            
            #if DEBUG
            print("Status : \(status)")
            #endif
            
            if status == .succeeded{
                return prediction
            } else if status.isTerminated{
                throw ReplicateAPI.Errors.terminated
            }
        }
        
        // timeout
        throw ReplicateAPI.Errors.timeout
    }
    
    /// Calling this operation starts a new prediction for the version and inputs you provide. As models can take several seconds or more to run, the output will not be available immediately. To get the final result of the prediction you should either provide a webhook URL for us to call when the results are ready, or poll the get a prediction endpoint until it has one of the terminated statuses.
    /// - Parameter body: Request body
    /// - Returns: Created prediction
    private func launchPrediction<Input: Encodable, Output: Decodable>(
        with body : HttpBody<Input>
    ) async throws -> Prediction<Output>{
        
        let rule = [Http.Validate.status(.range(200..<500))]
        let result : Http.Response<Prediction<Output>> = try await client.post(
            path: "predictions",
            body : body,
            validate: rule
        )
        
        return result.value
    }
}

// MARK: - File private -

/// Client configuration type alias
fileprivate typealias ClientConfig = Http.Configuration<ReplicateAPI.JsonReader,JsonWriter>

/// Client configuration
/// - Parameter endpoint: Replicate endpoint
fileprivate func clientCfg(baseURL: URL, apiKey: String)
    -> ClientConfig{
        
        let session = URLSession(configuration: sessionCfg(apiKey))
        
        return .init(
            reader: ReplicateAPI.JsonReader(),
            writer: JsonWriter(),
            baseURL: baseURL,
            session: session)
}


/// Get session configuration
/// - Parameter token: Api token
/// - Returns: URLSessionConfiguration
fileprivate func sessionCfg (_ token : String) -> URLSessionConfiguration{
    
    let config = URLSessionConfiguration.default
    
    config.httpAdditionalHeaders = [
        "Authorization": "Token \(token)",
        "application/json" : "Accept"
    ]
    
    return config
}
