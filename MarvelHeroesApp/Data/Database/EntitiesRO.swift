//
//  EntitiesRO.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 11.04.2024.
//

import Foundation
import RealmSwift

class ListOfHeroesRO: Object {
    @Persisted var results: List<HeroRO>
    
    override init() {
        self.results = List<HeroRO>()
    }
    
    convenience init(heroesData: [HeroModel]) {
        self.init()
        
        heroesData.forEach({ hero in
            self.results.append(HeroRO(heroData: hero))
        })
    }
}

class HeroRO: Object {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var heroDescription: String
    @objc dynamic var thumbnail: ThumbnailRO?
    
    convenience init(heroData: HeroModel) {
        self.init()
        
        self.id = heroData.id
        self.name = heroData.name
        self.heroDescription = heroData.heroDescription
        self.thumbnail = ThumbnailRO(heroImageData: heroData.thumbnail)
    }
    
    override init() {
        self.id = 0
        self.name = ""
        self.heroDescription = ""
        self.thumbnail = ThumbnailRO()
    }
}

class ThumbnailRO: EmbeddedObject {
    @objc dynamic var path: String
    @objc dynamic var `extension`: String
    
    override init() {
        self.path = ""
        self.`extension` = ""
    }
    
    convenience init(heroImageData: ThumbnailModel) {
        self.init()
        
        self.path = heroImageData.path
        self.extension = heroImageData.extension
    }
}
