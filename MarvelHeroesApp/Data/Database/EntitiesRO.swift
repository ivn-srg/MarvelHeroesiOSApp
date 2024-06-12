//
//  EntitiesRO.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 11.04.2024.
//

import Foundation
import RealmSwift

final class HeroRO: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var heroDescription: String = ""
    @Persisted var thumbnail: ThumbnailRO?
    
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

final class ThumbnailRO: EmbeddedObject {
    @Persisted var path: String
    @Persisted var `extension`: String
    
    convenience init(heroImageData: ThumbnailModel) {
        self.init()
        
        self.path = heroImageData.path
        self.extension = heroImageData.extension
    }
}

final class CachedImageData: Object {
    @Persisted var id: String = ""
    @Persisted var url: String = ""
    @Persisted var imageData: Data? = nil
    
    override public static func primaryKey() -> String? {
        "id"
    }
    
    convenience init(url: String, imageData: Data?) {
        self.init()
        
        self.id = UUID().uuidString
        self.url = url
        self.imageData = imageData
    }
}
