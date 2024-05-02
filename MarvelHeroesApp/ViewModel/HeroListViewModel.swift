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
    
    func fetchHeroesData(into collectionView: UICollectionView, needRefresh: Bool = false) {
        
        LoadingIndicator.startLoading()
        
        dataSource = realmDb.getHeroes()
        
        if dataSource.isEmpty || needRefresh {
            DispatchQueue.global().async {
                APIManager.shared.fetchHeroesData() { [weak self] (result) in
                    guard self != nil else { return }
                    
                    switch result {
                    case .success(let heroes):
                        let filteredHeroes = heroes.filter { $0.thumbnail.path != heroImageNotAvailable }
                        
                        if filteredHeroes.count > 0 {
                            let statusOfSaving = self?.realmDb.saveHeroes(heroes: filteredHeroes)
                            self?.dataSource = self?.realmDb.getHeroes() ?? [mockUpHeroData]
                            print("Saving status \(statusOfSaving ?? false)")
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
        } else {
            LoadingIndicator.stopLoading()
        }
    }
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count != 0 ? dataSource.count : 0
    }
}

