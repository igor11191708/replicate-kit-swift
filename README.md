# Replicate toolkit for swift

Replicate is a service that lets you run machine learning models with a few lines of code, without needing to understand how machine learning works. This package is the swift layer between Replicate API and your application.

 [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Freplicate-kit-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/replicate-kit-swift) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Freplicate-kit-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/replicate-kit-swift)
 
  ![The concept](https://github.com/The-Igor/replicate-kit-swift/blob/main/img/image_01.png) 
 
 ## How to use
 
### Authentication
All API requests must be authenticated with a token. Include this header with all request
 Get your API key [get your API key](https://replicate.com/) 

```swift
        let url = URL(string: ReplicateAPI.Endpoint.baseURL)!
        let apiKey = "your API key"
        api = ReplicateAPI(baseURL: url, apiKey: apiKey)
```

### Get a model

- owner - The name of the user or organization that owns the model
- name - The name of the model
```swift
    
   let model = try await api.getModel(owner: item.owner, name: item.name)
```

### Create prediction and get result

Calling this operation starts a new prediction for the version and inputs you provide. As models can take several seconds or more to run, the output will not be available immediately. To get the final result of the prediction you should either provide a webhook URL for us to call when the results are ready, or poll the get a prediction endpoint until it has one of the terminated statuses.

```swift

    guard let latest = model.latestVersion else {
        throw Errors.latestVersionIsEmpty
    }

    /// URL to the result 
    let output: [String]? = try await api.createPrediction(
            version: latest.id,
            input: input.params /// ["prompt": "an astronaut riding a horse on mars"]
    ).output
```

```json
"output": [
    "https://replicate.com/api/models/stability-ai/stable-diffusion/files/9c3b6fe4-2d37-4571-a17a-83951b1cb120/out-0.png"
  ]
```

Each time a prediction generates an output (note that predictions can generate multiple outputs)

![The concept](https://github.com/The-Igor/replicate-kit-swift/blob/main/img/image_03.png) 

## Replicate API

```swift
    /// Get a collection of models
    /// - Parameter collection_slug: The slug of the collection, like super-resolution or image-restoration
    /// - Returns: a collection of models
    public func getCollections(collection_slug : String) async throws -> CollectionOfModels
```
```swift
    /// - Parameters:
    ///   - owner: Model owner
    ///   - name: Model name
    public func getModel(owner: String, name: String) async throws -> Model
```    

```swift
    /// - Parameters:
    ///   - versionId: Version id
    ///   - input: Input data
    ///   - expect: Logic for awaiting a prediction Check out ``ReplicateAPI.Expect``
    ///  - webhook: An HTTPS URL for receiving a webhook when the prediction has new output.
    /// - Returns: Prediction result
    public func createPrediction<Input: Encodable, Output: Decodable>(
        version id : String,
        input: Input,
        expect: Expect = .yes(),
        webhook: URL? = nil
    ) async throws -> Prediction<Output>

```

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## SwiftUI example for the package
**I'll put it out as it is completely finished**

![The concept](https://github.com/The-Igor/replicate-kit-swift/blob/main/img/image_02.png) 


