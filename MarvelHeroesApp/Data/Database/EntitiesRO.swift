//
//  EntitiesRO.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 11.04.2024.
//

import Foundation
import RealmSwift

//class ListOfHeroesRO: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var results: List<HeroRO>
//    
//    convenience init(heroesData: [HeroModel]) {
//        self.init()
//        
//        heroesData.forEach({ hero in
//            self.results.append(HeroRO(heroData: hero))
//        })
//    }
//}

class HeroRO: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var heroDescription: String = ""
    @Persisted var thumbnail: ThumbnailRO?
    
    // MARK: Primary Key
    
    override public static func primaryKey() -> String? {
        "id"
    }
    
    convenience init(heroData: HeroModel) {
        self.init()
        self.id = heroData.id
        self.name = heroData.name
        self.heroDescription = heroData.heroDescription
        self.thumbnail = ThumbnailRO(heroImageData: heroData.thumbnail)
    }
}

class ThumbnailRO: EmbeddedObject {
    @Persisted var path: String
    @Persisted var `extension`: String
    
    convenience init(heroImageData: ThumbnailModel) {
        self.init()
        
        self.path = heroImageData.path
        self.extension = heroImageData.extension
    }
}
