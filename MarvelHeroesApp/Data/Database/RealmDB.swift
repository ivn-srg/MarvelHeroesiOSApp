//
//  RealmDB.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.04.2024.
//

import Foundation
import RealmSwift

protocol HeroDAO {
    func saveHeroes(heroes: [HeroModel]) -> (Bool)
    func getHeroes()-> [HeroModel]
}

class RealmDB {
    
    static let shared : RealmDB = RealmDB()
}

// MARK: - Hero
extension RealmDB: HeroDAO {
    
    func saveHeroes(heroes: [HeroModel]) -> (Bool) {
        do {
            let realm = try Realm()
            
            for item in heroes {
                try realm.write {
                    realm.add(HeroRO(heroData: item), update: .modified)
                }
            }
        } catch {
            return false
        }
        return true
    }
    
    func getHeroes() -> [HeroModel] {
        do {
            let realm = try Realm()
            
            var heroes: [HeroModel] = []
            let realmObject = realm.objects(HeroRO.self)
            
            for item in realmObject {
                heroes.append(HeroModel(heroRO: item))
            }
            return heroes
        } catch {
            return []
        }
    }
    
    func saveHero(hero: HeroModel) -> (Bool) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(HeroRO(heroData: hero), update: .modified)
            }
        } catch {
            return false
        }
        return true
    }
    
    func getHero(by itemId: Int) -> HeroRO? {
        do {
            let realm = try Realm()
            
            if let realmHeroObject = realm.objects(HeroRO.self).filter("id == %@", itemId).first {
                return realmHeroObject
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
