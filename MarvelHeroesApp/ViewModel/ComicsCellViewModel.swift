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
    func getImage() async throws -> UIImage {
        let urlString = try apiService.urlString(endpoint: .finalURL, offset: nil, entityId: nil, finalURL: resourseURI)
        
        if let comicsData = RealmManager.shared.getComics(by: resourseURI) {
            if let thumbnail = comicsData.thumbnail {
                return try await apiService.getImage(url: thumbnail.fullPath)
            } else {
                throw HeroError.unexpectedData
            }
        } else {
            do {
                let comicsData = try await apiService.performRequest(
                    from: urlString,
                    modelType: DataWrapper<ComicsItemModel>.self
                )
                guard comicsData.data.count > 0, let fetchedComics = comicsData.data.results.first else {
                    comicsInfo = ComicsItemModel()
                    throw HeroError.serializationError("error with data \(comicsData)".errorString)
                }
                comicsInfo = fetchedComics
                if let comicsInfo = comicsInfo {
                    return try await apiService.getImage(url: comicsInfo.thumbnail.fullPath)
                } else {
                    throw HeroError.serializationError("comicsInfo is null".errorString)
                }
            } catch {
                throw HeroError.otherNetworkError(error)
            }
        }
    }
}
