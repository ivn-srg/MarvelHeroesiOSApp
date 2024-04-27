//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import RealmSwift
import UIKit

final class HeroListViewModel {
    
    var dataSource: Results<HeroRO>!
    
    // MARK: - Network work
    
    func fetchHeroesData(into collectionView: UICollectionView) {
        let realm = try! Realm()
        
        LoadingIndicator.startLoading()
        
        dataSource = realm.objects(HeroRO.self)
        
        if dataSource.isEmpty {
            DispatchQueue.global().async {
                APIManager.shared.fetchHeroesData() { [weak self] (result) in
                    guard self != nil else { return }
                    
                    switch result {
                    case .success(let heroes):
                        let filteredHeroes = heroes.filter { $0.thumbnail.path != heroImageNotAvailable }
                        let heroesRO = filteredHeroes.map { HeroRO(heroData: $0) }
                        let realm = try! Realm()
                        
                        do {
                            try realm.write({
                                realm.add(heroesRO)
                            })
                        } catch {
                            print(error)
                        }
                        self?.dataSource = realm.objects(HeroRO.self)
                        
                        DispatchQueue.main.async {
                            LoadingIndicator.stopLoading()
                            collectionView.reloadData()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            LoadingIndicator.stopLoading()
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count != 0 ? dataSource.count : 0
    }
}

