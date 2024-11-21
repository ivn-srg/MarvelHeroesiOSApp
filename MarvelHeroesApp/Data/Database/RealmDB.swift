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
    func getHeroes()-> Heroes
}

final class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    private var realm: Realm?

    func setupRealm() {
        DispatchQueue.main.sync {
            do {
                self.realm = try Realm()
            } catch {
                print("Error initializing Realm: \(error)")
            }
        }
    }

    func getRealm() -> Realm? {
        if Thread.isMainThread {
            return realm
        } else {
            return DispatchQueue.main.sync {
                return realm
            }
        }
    }
}

extension RealmManager {
    func asyncGetRealm() async -> Realm? {
        return await MainActor.run {
            return self.getRealm()
        }
    }

    func fetchCachedImage(url: String) async -> CachedImageData? {
        guard let realm = await asyncGetRealm() else { return nil }

        let cachedImage = realm.objects(CachedImageData.self).filter { $0.url == url }.first
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
    
    func getHeroes() -> Heroes {
        do {
            let realm = try Realm()
            
            var heroes: Heroes = []
            let realmObject = realm.objects(HeroRO.self)
            
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
