//
//  GeneralModels.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

import RealmSwift
import Foundation

// MARK: - Stories
struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: String
    
    static var empty: Self { .init(resourceURI: "", name: "", type: "") }
    
    init(resourceURI: String, name: String, type: String) {
        self.resourceURI = resourceURI
        self.name = name
        self.type = type
    }
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

// MARK: - DateElement
struct DateElement: Codable {
    let type: String
    let date: String
}

enum DateType: String, Codable {
    case digitalPurchaseDate = "digitalPurchaseDate"
    case focDate = "focDate"
    case onsaleDate = "onsaleDate"
    case unlimitedDate = "unlimitedDate"
}

enum Extension: String, Codable {
    case jpg = "jpg"
    case gif = "gif"
}

// MARK: - Price
struct Price: Codable {
    enum PriceType: String, Codable {
        case digitalPurchasePrice = "digitalPurchasePrice"
        case printPrice = "printPrice"
    }
    
    let type: PriceType
    let price: Double
}

// MARK: - TextObject
struct TextObject: Codable {
    let type: String
    let language: String
    let text: String
}

enum URLType: String, Codable {
    case detail = "detail"
    case inAppLink = "inAppLink"
    case purchase = "purchase"
    case reader = "reader"
}

enum TypeEnum: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

extension Thumbnail {
    init() {
        self.path = ""
        self.thumbnailExtension = ""
    }
    
    init(thumbRO: ThumbnailRO) {
        self.path = thumbRO.path
        self.thumbnailExtension = thumbRO.thumbnailExtension
    }
    
    var fullPath: String {
        "\(self.path).\(self.thumbnailExtension)"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}
