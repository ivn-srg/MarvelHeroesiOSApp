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
    
    var heroItem: HeroRO
    
    init(hero: HeroRO) {
        self.heroItem = hero
    }
    
    // MARK: - Network work

    func fetchHeroData() {
        LoadingIndicator.startLoading()
        
        APIManager.shared.fetchHeroData(heroItem: heroItem) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    LoadingIndicator.stopLoading()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    LoadingIndicator.stopLoading()
                }
                print(error)
            }
        }
    }
}
