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
    let description: String
    let thumbnail: ThumbnailModel
}

struct ThumbnailModel: Codable {
    let path: String
    let `extension`: String
}

typealias Heroes = [HeroModel]
