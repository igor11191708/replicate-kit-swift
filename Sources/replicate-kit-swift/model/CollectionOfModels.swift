//
//  CollectionOfModels.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

/// The response is a collection object with a nested list of model objects within that collection
/// https://replicate.com/docs/reference/http#get-collection
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CollectionOfModels: Hashable, Decodable{
        
    /// Collection name
    public let name : String
    
    /// Collection slug The slug of the collection, like super-resolution or image-restoration.
    public let slug : String
    
    ///Description
    public let description : String
    
    /// List of models
    public let models : [Model]
}
