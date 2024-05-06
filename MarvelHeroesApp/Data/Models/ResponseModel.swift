//
//  ResponseModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import Foundation

struct ResponseModel: Codable {
    let code: Int
    let status: String
    let data: ListOfHeroesModel
}

struct ListOfHeroesModel: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [HeroModel]
}

struct HeroModel: Codable {
    let id: Int
    let name: String
    let heroDescription: String
    let thumbnail: ThumbnailModel
    
    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail
        case heroDescription = "description"
    }
}

struct ThumbnailModel: Codable {
    let path: String
    let `extension`: String
}

typealias Heroes = [HeroModel]

extension HeroModel {
    init() {
        self.id = 0
        self.name = ""
        self.heroDescription = ""
        self.thumbnail = ThumbnailModel()
    }
    
    init(heroRO: HeroRO) {
        self.id = heroRO.id
        self.name = heroRO.name
        self.heroDescription = heroRO.heroDescription
        self.thumbnail = ThumbnailModel(thumbRO: heroRO.thumbnail ?? ThumbnailRO())
    }
}

extension ThumbnailModel {
    init() {
        self.path = ""
        self.`extension` = ""
    }
    
    init(thumbRO: ThumbnailRO) {
        self.path = thumbRO.path
        self.extension = thumbRO.extension
    }
}
