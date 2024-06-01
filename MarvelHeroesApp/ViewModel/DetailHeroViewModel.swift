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
    var realmDb = RealmDB.shared
    
    init(hero: HeroRO) {
        self.heroItem = hero
    }
    
    // MARK: - Network work
    
    func fetchHeroData() {
        LoadingIndicator.startLoading()
        
        APIManager.shared.fetchHeroData(heroItem: heroItem) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let heroData):
                let statusOfSaving = self?.realmDb.saveHero(hero: heroData)
                self?.heroItem = HeroRO(heroData: heroData)
                
                DispatchQueue.main.async {
                    LoadingIndicator.stopLoading()
                }
            case .failure(let error):
                if let heroId = self?.heroItem.id, let heroData = self?.realmDb.getHero(by: heroId) {
                    self?.heroItem = heroData
                } else {
                    self?.heroItem = HeroRO(heroData: mockUpHeroData)
                }
                
                DispatchQueue.main.async {
                    LoadingIndicator.stopLoading()
                }
                print(error)
            }
        }
    }
}
