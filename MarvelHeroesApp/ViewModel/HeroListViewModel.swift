//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import RealmSwift
import UIKit

final class HeroListViewModel {
    
    var dataSource: [HeroModel] = []
    var realmDb = RealmDB.shared
    
    // MARK: - Network work
    
    func fetchHeroesData(into collectionView: UICollectionView) {
        
        LoadingIndicator.startLoading()
        
        dataSource = realmDb.getHeroes()
        
        if dataSource.isEmpty {
            DispatchQueue.global().async {
                APIManager.shared.fetchHeroesData() { [weak self] (result) in
                    guard self != nil else { return }
                    
                    switch result {
                    case .success(let heroes):
                        print(heroes)
                        let filteredHeroes = heroes.filter { $0.thumbnail.path != heroImageNotAvailable }
//                        let heroesRO = filteredHeroes.map { HeroRO(heroData: $0) }
                        if filteredHeroes.count > 0 {
                            let statusOfSaving = self?.realmDb.saveHeroes(heroes: filteredHeroes)
                            self?.dataSource = self?.realmDb.getHeroes() ?? [mockUpHeroData]
                        }
                        
                        DispatchQueue.main.async {
                            LoadingIndicator.stopLoading()
                            collectionView.reloadData()
                        }
                    case .failure(let error):
                        self?.dataSource = self?.realmDb.getHeroes() ?? [mockUpHeroData]
                        
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
        print(dataSource)
        return dataSource.count != 0 ? dataSource.count : 0
    }
}

