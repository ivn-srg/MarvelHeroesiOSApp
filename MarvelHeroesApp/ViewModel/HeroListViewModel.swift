//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import Foundation

let mockDataOfHeroes =  ResponseModel(
    status: true,
    result: ListOfHeroesModel(
        totalCount: 9,
        entities: [
            HeroModel(name: "Deadpool", imageName: "deadPool", color: 0x770309),
            HeroModel(name: "Iron Man", imageName: "ironMan", color: 0x94141a),
            HeroModel(name: "Captain America", imageName: "captainAmerica", color: 0x3d50b5),
            HeroModel(name: "Spiderman", imageName: "spiderMan", color: 0x981518),
            HeroModel(name: "Doctor Strange", imageName: "drStrange", color: 0x0a7a53),
            HeroModel(name: "Thor", imageName: "thor", color: 0x0b84ba),
            HeroModel(name: "Thanos", imageName: "thanos", color: 0x6c0fc5),
            HeroModel(name: "Hulk", imageName: "hulk", color: 0x008000),
            HeroModel(name: "Black Panther", imageName: "panther", color: 0x000000)
        ]
    )
)

class HeroListViewModel {
    
    var dataSource: [HeroModel] = []
    
    init() {
        updateDataSource()
    }
    
    // MARK: - Network work
    
    func updateDataSource() {
        self.dataSource = mockDataOfHeroes.result.entities
    }
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
    
    
}

