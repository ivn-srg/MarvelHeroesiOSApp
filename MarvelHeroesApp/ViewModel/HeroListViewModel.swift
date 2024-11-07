//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import RealmSwift
import UIKit

final class HeroListViewModel {
    
    var dataSource: [HeroItemModel] = []
    var realmDb = RealmDB.shared
    let networkService = ApiServiceConfiguration.shared.apiService
    
    // MARK: - Network work
    
    func fetchHeroesData(into collectionView: UICollectionView, needRefresh: Bool = false, needsLoadMore: Bool = false) throws {
        
        LoadingIndicator.startLoading()
        
        if dataSource.isEmpty || needRefresh || needsLoadMore {
            let offset = needsLoadMore ? countOfRow() : 0
            let urlString = try apiManager.urlString(endpoint: .getHeroes, offset: offset)
            
            Task {
                do {
                    let heroesData = try await networkService.performRequest(
                        from: urlString,
                        modelType: ResponseModel<HeroItemModel>.self
                    )
                    if heroesData.data.count > 0 {
                        let statusOfSaving = realmDb.saveHeroes(heroes: heroesData.data.results)
                        dataSource.append(contentsOf: heroesData.data.results)
                        print("Saving status \(statusOfSaving)")
                    }
                    
                } catch {
                    let cashedHeroed = realmDb.getHeroes()
                    dataSource = cashedHeroed.isEmpty ? [mockUpHeroData] : cashedHeroed
                    print(error)
                }
                LoadingIndicator.stopLoading()
                await collectionView.reloadData()
            }
        } else {
            LoadingIndicator.stopLoading()
        }
    }
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
}

