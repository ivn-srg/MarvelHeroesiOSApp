//
//  RealmDB.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.04.2024.
//

import Foundation
import RealmSwift

protocol HeroDAO {
    func saveHeroes(heroes: Heroes) -> (Bool)
    func getHeroes(exclude excludedHeroes: Heroes)-> Heroes
}

final class RealmManager {
    static let shared = RealmManager()
    
    private var realm: Realm?
    
    private init() {}
    
    private func createRealmInstance() -> Realm? {
        do {
            return try Realm()
        } catch {
            print("Error initializing Realm: \(error)")
            return nil
        }
    }

    func getRealm() -> Realm? {
        createRealmInstance()
    }
}

extension RealmManager {
    func fetchCachedImage(url: String) async -> CachedImageData? {
        guard let realm = getRealm() else { return nil }

        let cachedImage = realm.objects(CachedImageData.self).filter("url == %@", url).first
        return cachedImage
    }
}



// MARK: - Hero
extension RealmManager: HeroDAO {
    
    func saveHeroes(heroes: Heroes) -> (Bool) {
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
    
    func getHeroes(exclude excludedHeroes: Heroes = []) -> Heroes {
        do {
            let realm = try Realm()
            
            var heroes: Heroes = []
            let realmObject: Results<HeroRO>
            
            if excludedHeroes.isEmpty {
                realmObject = realm.objects(HeroRO.self)
            } else {
                let idsOfExcludedHeroes = excludedHeroes.map { $0.id }
                realmObject = realm.objects(HeroRO.self).filter("NOT (id IN %@)", idsOfExcludedHeroes)
            }
            
            for item in realmObject {
                heroes.append(HeroItemModel(cashedHero: item))
            }
            return heroes
        } catch {
            return []
        }
    }
    
    func saveHero(hero: HeroItemModel) -> (Bool) {
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
    
    func saveComics(_ comics: ComicsItemModel) -> (Bool) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(ComicsItemModelRO(comicsData: comics), update: .modified)
            }
        } catch {
            return false
        }
        return true
    }
    
    func getComics(by resourseURI: String) -> ComicsItemModelRO? {
        do {
            let realm = try Realm()
            
            if let realmComicsObject = realm.objects(ComicsItemModelRO.self).filter("resourceURI == %@", resourseURI).first {
                return realmComicsObject
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
