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
    
    func fetchHeroData() throws {
        LoadingIndicator.startLoading()
        let urlString = try apiManager.urlString(endpoint: .getHero, entityId: heroItem.id)
        
        Task {
            do {
                let heroData = try await networkService.performRequest(
                    from: urlString,
                    modelType: ResponseModel<HeroItemModel>.self
                )
                guard heroData.data.count > 0, let fetchedHeroItem = heroData.data.results.first else {
                    heroItem = HeroRO(heroData: mockUpHeroData)
                    return
                }
                let _ = realmDb.saveHero(hero: fetchedHeroItem)
                heroItem = HeroRO(heroData: fetchedHeroItem)
            } catch {
                if let heroData = realmDb.getHero(by: heroItem.id) {
                    heroItem = heroData
                } else {
                    heroItem = HeroRO(heroData: mockUpHeroData)
                }
                print(error)
            }
            LoadingIndicator.stopLoading()
        }
    }
    
    func getHeroImage(from url: String, to heroImageView: UIImageView) {
        networkService.getImageForHero(url: url, imageView: heroImageView)
    }
}
