//
//  APIMockService.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import Foundation
import UIKit

final class APIMockManager: ApiServiceProtocol {
    func urlString(endpoint: APIType, offset: Int?, entityId: Int?, finalURL: String?) throws -> String { "" }
    
    func performRequest<T>(from urlString: String, modelType: T.Type) async throws -> T where T : Decodable {
        return try await makeHTTPRequest(for: URLRequest(url: URL(string: urlString)!), codableModelType: DataWrapper<HeroItemModel>.self) as! T
    }
    
    func makeHTTPRequest<T>(for request: URLRequest, codableModelType: T.Type) async throws -> T where T : Decodable {
        let list = [
            HeroItemModel(
                id: 1,
                name: "Deadpool",
                description: "This is the craziest hero in Marvel spacs!",
                modified: "",
                thumbnail: Thumbnail(
                    path: "Deadpool",
                    thumbnailExtension: ""
                ),
                resourceURI: "",
                comics: .empty,
                series: .empty,
                stories: .empty,
                events: .empty,
                urls: []
            ),
            HeroItemModel(
                id: 2,
                name: "Iron Man",
                description: "Robert is a clever guy",
                modified: "",
                thumbnail: Thumbnail(
                    path: "Iron Man",
                    thumbnailExtension: ""
                ),
                resourceURI: "",
                comics: .empty,
                series: .empty,
                stories: .empty,
                events: .empty,
                urls: []
            )
        ]
        return try JSONDecoder().decode(codableModelType, from: list.description.data(using: .utf8)!)
    }
    
    
    public static let shared = APIMockManager()
    
    func fetchHeroesData(from offset: Int, completion: @escaping (Result<Heroes, any Error>) -> Void) {
        let response = [
            HeroItemModel(
                id: 1,
                name: "Deadpool",
                description: "This is the craziest hero in Marvel spacs!",
                modified: "",
                thumbnail: Thumbnail(
                    path: "Deadpool",
                    thumbnailExtension: ""
                ),
                resourceURI: "",
                comics: .empty,
                series: .empty,
                stories: .empty,
                events: .empty,
                urls: []
            ),
            HeroItemModel(
                id: 2,
                name: "Iron Man",
                description: "Robert is a clever guy",
                modified: "",
                thumbnail: Thumbnail(
                    path: "Iron Man",
                    thumbnailExtension: ""
                ),
                resourceURI: "",
                comics: .empty,
                series: .empty,
                stories: .empty,
                events: .empty,
                urls: []
            )
        ]
        completion(.success(response))
    }
    
    func fetchHeroData(heroItem: HeroRO, completion: @escaping (Result<HeroItemModel, any Error>) -> Void) {
        let heroInfo = HeroItemModel(
            id: heroItem.id,
            name: heroItem.name,
            description: heroItem.heroDescription,
            modified: "",
            thumbnail: Thumbnail(
                thumbRO: heroItem.thumbnail ?? ThumbnailRO()
            ),
            resourceURI: "",
            comics: .empty,
            series: .empty,
            stories: .empty,
            events: .empty,
            urls: []
        )
        completion(.success(heroInfo))
    }
    
    func getImageForHero(url: String, imageView: UIImageView) {
        if url == "Deadpool." {
            imageView.image = UIImage(named: "deadPool")
        } else if url == "Iron Man." {
            imageView.image = UIImage(named: "ironMan")
        } else {
            imageView.image = UIImage(named: "mockup")
        }
    }
}
