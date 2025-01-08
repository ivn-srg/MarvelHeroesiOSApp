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
    var realmDb = RealmManager.shared
    let networkService = ApiServiceConfiguration.shared.apiService
    
    // MARK: - Network work
    
    func fetchHeroesData(
        into collectionView: UICollectionView,
        needRefresh: Bool = false,
        needsLoadMore: Bool = false
    ) async throws {
        await MainActor.run {
            LoadingIndicator.startLoading()
        }
        
        if dataSource.isEmpty || needRefresh || needsLoadMore {
            let offset = needsLoadMore ? countOfRow() : 0
            let urlString = try apiManager.urlString(endpoint: .getHeroes, offset: offset)
            
            do {
                let cashedHeroes = realmDb.getHeroes(exclude: dataSource)
                dataSource.append(contentsOf: cashedHeroes)
                
                if cashedHeroes.isEmpty {
                    let heroesData = try await networkService.performRequest(
                        from: urlString,
                        modelType: DataWrapper<HeroItemModel>.self
                    )
                    
                    if heroesData.data.count > 0 {
                        let statusOfSaving = realmDb.saveHeroes(heroes: heroesData.data.results)
                        dataSource.append(contentsOf: heroesData.data.results)
                        print("Saving status \(statusOfSaving)")
                    }
                }
            } catch {
                dataSource = [mockUpHeroData]
                print(error)
            }
            
            await MainActor.run {
                LoadingIndicator.stopLoading()
                collectionView.reloadData()
            }
        } else {
            await MainActor.run {
                LoadingIndicator.stopLoading()
            }
        }
    }
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
}

