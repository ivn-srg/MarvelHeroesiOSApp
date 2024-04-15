//
//  RealmDB.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.04.2024.
//

import Foundation
import RealmSwift

class RealmDB {
    
    static let shared : RealmDB = RealmDB()
}

// MARK: - Hero
extension RealmDB : HeroDAO {
    
    func saveHeroes(heroes: [HeroModel]) -> (Bool) {
        let realm = try! Realm()
        
        do {
            for item in heroes {
                try realm.write {
                    realm.add(HeroRO(heroData: item), update: .all)
                }
            }
        } catch {
            return false
        }
        return true
    }
    
    func getHeroes() -> [HeroModel] {
        let realm = try! Realm()
        
        var heroes: [HeroModel] = []
        let realmObject = realm.objects(HeroRO.self)
        
        for item in realmObject {
            heroes.append(HeroModel(heroRO: item))
        }
        return heroes
    }
}
