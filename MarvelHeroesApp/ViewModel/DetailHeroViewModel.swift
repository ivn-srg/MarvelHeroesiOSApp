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
    private let networkService = ApiServiceConfiguration.shared.apiService
    var realmDb = RealmDB.shared
    
    init(hero: HeroRO) {
        self.heroItem = hero
    }
    
    // MARK: - Network work
    
    func fetchHeroData() {
        LoadingIndicator.startLoading()
        
        networkService.fetchHeroData(heroItem: heroItem) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let heroData):
                let _ = self?.realmDb.saveHero(hero: heroData)
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
    
    func getHeroImage(from url: String, to heroImageView: UIImageView) {
        networkService.getImageForHero(url: url, imageView: heroImageView)
    }
}
