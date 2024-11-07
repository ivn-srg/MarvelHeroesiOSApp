//
//  GeneralModels.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

import RealmSwift

// MARK: - Stories
struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: ItemType
    
    static var empty: Self { .init(resourceURI: "", name: "", type: .empty) }
}

// MARK: - Comics
struct ComicsItem: Codable {
    let resourceURI: String
    let name: String
    
    static var empty: Self { .init(resourceURI: "", name: "") }
}

// MARK: - Creators
struct CreatorsItem: Codable {
    enum Role: String, Codable {
        case colorist = "colorist"
        case editor = "editor"
        case inker = "inker"
        case letterer = "letterer"
        case other = "other"
        case penciler = "penciler"
        case penciller = "penciller"
        case pencillerCover = "penciller (cover)"
        case writer = "writer"
    }
    
    let resourceURI: String
    let name: String
    let role: Role
    
    static var empty: Self { .init(resourceURI: "", name: "", role: .other) }
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String
    let name: String
    
    static var empty: Self { .init(resourceURI: "", name: "") }
}
