//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import Foundation
import UIKit

final class HeroListViewModel {
    
    var dataSource: [HeroModel] = []
    
    // MARK: - Network work
    
    func fetchHeroesData(into collectionView: UICollectionView) {
        LoadingIndicator.startLoading()
        APIManager.shared.fetchHeroesData() { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let heroes):
                LoadingIndicator.stopLoading()
                self?.dataSource = heroes
                collectionView.reloadData()
            case .failure(let error):
                LoadingIndicator.stopLoading()
                print(error)
            }
        }
    }

    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
}

