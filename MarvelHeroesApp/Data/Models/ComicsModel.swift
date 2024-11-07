//
//  ComicsModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

import Foundation

struct ComicsItemModel: Codable {
    let id, digitalId: Int
    let title: String
    let issueNumber: Int
    let variantDescription: String
    let description: String
    let modified: String
    let isbn: String
    let upc: String
    let diamondCode: String
    let ean: String
    let issn: String
    let format: String
    let pageCount: Int
    let textObjects: [TextObject]
    let resourceURI: String
    let urls: [URLElement]
    let series: Series
    let variants, collections, collectedIssues: [Series]
    let dates: [DateElement]
    let prices: [Price]
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    let creators: ShortInfoItemModel<Series>
    let characters: ShortInfoItemModel<Series>
    let stories: ShortInfoItemModel<StoriesItem>
    let events: ShortInfoItemModel<Series>
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: DateType
    let date: Date?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(DateType.self, forKey: .type)
        if let parsedDate = try container.decodeIfPresent(Date.self, forKey: .date) {
            self.date = parsedDate
            return
        }
        throw DecodingError.typeMismatch(
            DateElement.self,
            DecodingError.Context(codingPath: container.codingPath, debugDescription: "Wrong type for DateElement")
        )
    }
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
