//
//  ComicsCellViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import Foundation
import UIKit

final class GeneralCellViewModel: CellViewModelProtocol {
    // MARK: - Fields
    private let resourseURI: String
    private let cellType: EntitiesType
    private var apiService = ApiServiceConfiguration.shared.apiService
    
    // MARK: - life cycle
    init(cellType: EntitiesType, resourseURI: String) {
        self.cellType = cellType
        self.resourseURI = resourseURI
    }
    
    // MARK: - funcs
    func getImage() async throws -> UIImage {
        let urlString = try apiService.urlString(endpoint: .finalURL, offset: nil, entityId: nil, finalURL: resourseURI)
        
        if let entityData = RealmManager.shared.getComics(by: resourseURI) {
            if let thumbnail = entityData.thumbnail {
                return try await apiService.getImage(url: thumbnail.fullPath)
            } else {
                throw HeroError.unexpectedData
            }
        } else {
            return try await fetchImageFromPrimaryModel(urlString)
        }
    }
    
    private func fetchImageFromPrimaryModel(_ urlString: String) async throws -> UIImage {
        do {
            let thumbnailURL = try await fetchThumbnailURL(urlString)
            return try await apiService.getImage(url: thumbnailURL)
        } catch {
            throw HeroError.otherNetworkError(error)
        }
    }
    
    private func fetchThumbnailURL(_ urlString: String) async throws -> String  {
        func makeHttpRequest<T: Decodable>(model: T.Type) async throws -> T {
            try await apiService.performRequest(
                from: urlString,
                modelType: T.self
            )
        }
        
        let entityData: Item?
        switch cellType {
        case .comics:
            entityData = try await makeHttpRequest(model: DataWrapper<ComicsItemModel>.self).data.results.first
        case .stories:
            entityData = try await makeHttpRequest(model: DataWrapper<StoriesModel>.self).data.results.first
        case .creators:
            entityData = try await makeHttpRequest(model: DataWrapper<CreatorsModel>.self).data.results.first
        case .events:
            entityData = try await makeHttpRequest(model: DataWrapper<EventsModel>.self).data.results.first
        case .series:
            entityData = try await makeHttpRequest(model: DataWrapper<SeriesModel>.self).data.results.first
        }

        guard let fetchedEntityData = entityData else {
            throw HeroError.serializationError("error with data \(String(describing: entityData))".errorString)
        }

        return fetchedEntityData.thumbnail?.fullPath ?? "entity"
    }
}
