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
            HeroModel(
                name: "Deadpool",
                info: "This is Deadpool",
                imageName: "deadPool",
                color: 0x770309,
                urlImage: "https://clck.ru/39Nw8q"
            ),
            HeroModel(
                name: "Iron Man",
                info: "This is name",
                imageName: "ironMan",
                color: 0x94141a,
                urlImage: "https://iili.io/JMnuDI2.png"
            ),
            HeroModel(
                name: "Captain America",
                info: "This is name",
                imageName: "captainAmerica",
                color: 0x3d50b5,
                urlImage: "https://goo.su/Pr6hL"
            ),
            HeroModel(
                name: "Spiderman",
                info: "This is name",
                imageName: "spiderMan",
                color: 0x981518,
                urlImage: "https://goo.su/qBEKPid"
            ),
            HeroModel(
                name: "Doctor Strange",
                info: "This is name",
                imageName: "drStrange",
                color: 0x0a7a53,
                urlImage: "https://goo.su/QBvFNS"
            ),
            HeroModel(
                name: "Thor",
                info: "This is name",
                imageName: "thor",
                color: 0x0b84ba,
                urlImage: "https://goo.su/w6jWzHL"
            ),
            HeroModel(
                name: "Thanos",
                info: "This is name",
                imageName: "thanos",
                color: 0x6c0fc5,
                urlImage: "https://goo.su/Uapa6U"
            ),
            HeroModel(
                name: "Hulk",
                info: "This is name",
                imageName: "hulk",
                color: 0x008000,
                urlImage: "https://sul.su/7Oiq"
            ),
            HeroModel(
                name: "Black Panther",
                info: "This is name",
                imageName: "panther",
                color: 0x000000,
                urlImage: "https://sul.su/2ySw"
            )
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

