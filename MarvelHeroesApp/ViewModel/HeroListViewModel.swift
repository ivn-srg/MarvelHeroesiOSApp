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
                info: "Ha! No one can compare to me in jokes and battle!",
                imageName: "deadPool",
                color: 0x770309,
                urlImage: "https://clck.ru/39Nw8q"
            ),
            HeroModel(
                name: "Iron Man",
                info: "I've created armor that will be a terror to all villains",
                imageName: "ironMan",
                color: 0x94141a,
                urlImage: "https://iili.io/JMnuDI2.png"
            ),
            HeroModel(
                name: "Captain America",
                info: "I will protect my country and fight for justice to my last breath",
                imageName: "captainAmerica",
                color: 0x3d50b5,
                urlImage: "https://goo.su/Pr6hL"
            ),
            HeroModel(
                name: "Spiderman",
                info: "Great power comes with great responsibility",
                imageName: "spiderMan",
                color: 0x981518,
                urlImage: "https://goo.su/qBEKPid"
            ),
            HeroModel(
                name: "Doctor Strange",
                info: "My knowledge in magic knows no bounds, I can stop any threat",
                imageName: "drStrange",
                color: 0x0a7a53,
                urlImage: "https://goo.su/QBvFNS"
            ),
            HeroModel(
                name: "Thor",
                info: "With my hammer Mjölnir, I will strike a blow that will shake the very Universe",
                imageName: "thor",
                color: 0x0b84ba,
                urlImage: "https://goo.su/w6jWzHL"
            ),
            HeroModel(
                name: "Thanos",
                info: "Perfect balance must be restored, even if it requires sacrifice",
                imageName: "thanos",
                color: 0x6c0fc5,
                urlImage: "https://goo.su/Uapa6U"
            ),
            HeroModel(
                name: "Hulk",
                info: "I am the strongest! No one can stop my rage",
                imageName: "hulk",
                color: 0x008000,
                urlImage: "https://sul.su/7Oiq"
            ),
            HeroModel(
                name: "Black Panther",
                info: "I am the king of Wakanda and my suit-armor makes me invulnerable",
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

