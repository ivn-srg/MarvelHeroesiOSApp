//
//  DetailHeroViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher
import Alamofire
import CryptoKit

final class DetailHeroViewModel {
    
    var heroItem: HeroModel
    
    init(hero: HeroModel) {
        self.heroItem = hero
    }
    
    // MARK: - Network work

    func fetchHeroData() {
        LoadingIndicator.startLoading()
        
        APIManager.shared.fetchHeroData(heroItem: heroItem) { [weak self] (result) in
            guard let this = self else { return }
            
            switch result {
            case .success:
                LoadingIndicator.stopLoading()
            case .failure(let error):
                LoadingIndicator.stopLoading()
                print(error)
            }
        }
    }
}
