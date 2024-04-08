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
        DispatchQueue.global().async {
            APIManager.shared.fetchHeroesData() { [weak self] (result) in
                guard self != nil else { return }
                
                switch result {
                case .success(let heroes):
                    let filteredHeroes = heroes.filter { $0.thumbnail.path != heroImageNotAvailable }
                    self?.dataSource = filteredHeroes
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
    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
}

