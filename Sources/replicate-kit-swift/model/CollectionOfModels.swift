//
//  CollectionOfModels.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

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
