//
//  ResponseModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import Foundation

struct ResponseModel: Codable {
    let status: Bool
    let result: ListOfHeroesModel
}

struct ListOfHeroesModel: Codable {
    let totalCount: Int
    let entities: [HeroModel]
}

struct HeroModel: Codable {
    let name: String
    let imageName: String
    let color: Int
}
