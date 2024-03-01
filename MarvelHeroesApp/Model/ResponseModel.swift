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
    
    static let mockDataOfHeroes =  ResponseModel(
        status: true,
        result: ListOfHeroesModel(
            totalCount: 7,
            entities: [
                HeroModel(name: "Deadpool", imageName: "deadPool"),
                HeroModel(name: "Iron Man", imageName: "ironMan"),
                HeroModel(name: "Captain America", imageName: "captainAmerica"),
                HeroModel(name: "Spiderman", imageName: "spiderMan"),
                HeroModel(name: "Doctor Strange", imageName: "drStrange"),
                HeroModel(name: "Thor", imageName: "thor"),
                HeroModel(name: "Thanos", imageName: "thanos")
            ]
        )
    )
}

struct ListOfHeroesModel: Codable {
    let totalCount: Int
    let entities: [HeroModel]
}

struct HeroModel: Codable {
    let name: String
    let imageName: String
}
