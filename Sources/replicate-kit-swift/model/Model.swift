//
//  Model.swift
//  
//
//  Created by Igor on 08.03.2023.
//

import Foundation

///The response is a model object in the following format
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct Model: Hashable, Decodable {

    public let url: URL
    
    /// The name of the user or organization that owns the model.
    public let owner: String
    
    /// The name of the model
    public let name: String
    
    /// Description
    public let description: String
    
    /// Model visibility
    public let visibility: String
    
    /// Github url
    public let github_url: URL?

    public let paper_url: URL?

    /// License url
    public let license_url: URL?
    
    /// The **latest_version** is the model's most recently pushed version.
    private let latest_version: Version?
        
    /// Version of the model
    public struct Version: Hashable, Identifiable, Decodable {
        
        public let id: String

        public let created_at: String
    }
    
    /// The **latest_version** is the model's most recently pushed version.
    public var latestVersion : Version?{
        latest_version
    }
}
