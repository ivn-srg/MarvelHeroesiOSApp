//
//  ComicsCellViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import Foundation
import UIKit

final class ComicsCellViewModel: CellViewModelProtocol {
    // MARK: - Fields
    private let resourseURI: String
    private var comicsInfo: ComicsItemModel?
    private var apiService = ApiServiceConfiguration.shared.apiService
    
    // MARK: - life cycle
    init(resourseURI: String) {
        self.resourseURI = resourseURI
    }
    
    // MARK: - funcs
    func getImage(to targetImageView: UIImageView) async throws {
        let urlString = try apiService.urlString(endpoint: .clearlyURL, offset: nil, entityId: nil, finalURL: resourseURI)
        
        Task {
            do {
                let comicsData = try await apiService.performRequest(
                    from: urlString,
                    modelType: DataWrapper<ComicsItemModel>.self
                )
                guard comicsData.data.count > 0, let fetchedComics = comicsData.data.results.first else {
                    //comicsData = HeroRO(heroData: mockUpHeroData)
                    throw HeroError.serializationError("error with data \(comicsData)".errorString)
                }
                comicsInfo = fetchedComics
                if let comicsInfo = comicsInfo {
                    apiService.getImageForHero(url: comicsInfo.thumbnail.fullPath, imageView: targetImageView)
                } else {
                    throw HeroError.serializationError("comicsInfo is null".errorString)
                }
//                let _ = realmDb.saveHero(hero: fetchedHeroItem)
//                heroItem = HeroRO(heroData: fetchedHeroItem)
            } catch {
//                if let comicsData = realmDb.getHero(by: heroItem.id) {
//                    heroItem = heroData
//                } else {
//                    heroItem = HeroRO(heroData: mockUpHeroData)
//                }
                print(error)
            }
        }
    }
}
