//
//  APIManager.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.04.2024.
//

import Foundation
import Alamofire
import CryptoKit
import Kingfisher
import RealmSwift
import UIKit

protocol ApiServiceProtocol: AnyObject {
    func performRequest<T: Decodable>(
        from urlString: String,
        modelType: T.Type
    ) async throws -> T
    
    func makeHTTPRequest<T: Decodable>(
        for request: URLRequest,
        codableModelType: T.Type
    ) async throws -> T
    
    func getImageForHero(url: String, imageView: UIImageView)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIType {
    case getHeroes, getHero, getComics, getSeries, getStories, getCreators, getEvents
    
    private var baseURL: String {
        "https://gateway.marvel.com/v1/public/"
    }
    
    private var path: String {
        switch self {
        case .getHeroes: "characters"
        case .getHero: "characters"
        case .getComics: "comics"
        case .getSeries: "series"
        case .getStories: "stories"
        case .getCreators: "creators"
        case .getEvents: "events"
        }
    }
    
    var request: String {
        "\(baseURL)\(path)"
    }
}

enum HeroError: Error, LocalizedError {
    case invalidURL, parsingError(Error), serializationError(Error), noInternetConnection, timeout, otherNetworkError(Error)
}

final class ApiServiceConfiguration {
    public static let shared = ApiServiceConfiguration()

    private init() {}

    var apiService: ApiServiceProtocol {
        if shouldUseMockingService {
            return APIMockManager.shared
        } else {
            return APIManager.shared
        }
    }

    private var shouldUseMockingService: Bool = false

    func setMockingServiceEnabled() {
        shouldUseMockingService = true
    }
}

final class APIManager: ApiServiceProtocol {
    public static let shared = APIManager()
    
    private var currentTimeStamp: Int {
        Int(Date().timeIntervalSince1970)
    }
    private var md5Hash: String {
        MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
    }
    
    func urlString(endpoint: APIType, offset: Int? = nil, entityId: Int? = nil) throws -> String {
        let limit = 30
        
        switch endpoint {
        case .getHeroes, .getComics, .getCreators, .getEvents, .getSeries, .getStories:
            guard let offset = offset else { throw HeroError.invalidURL }
            return "\(endpoint.request)?limit=\(limit)&offset=\(offset)&ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        case .getHero:
            guard let entityId = entityId else { throw HeroError.invalidURL }
            return "\(endpoint.request)/\(entityId)&ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        }
    }
    
    func performRequest<T: Decodable>(
        from urlString: String,
        modelType: T.Type
    ) async throws -> T {
        guard let url = URL(string: urlString) else { throw HeroError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        return try await makeHTTPRequest(for: request, codableModelType: modelType)
    }
    
    internal func makeHTTPRequest<T: Decodable>(
        for request: URLRequest,
        codableModelType: T.Type
    ) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            do {
                let result = try JSONDecoder().decode(codableModelType, from: data)
                return result
            } catch {
                print("String(data: data, encoding: .utf8) \(String(data: data, encoding: .utf8))")
                print("error \(error)")
                let errorModel = try JSONDecoder().decode(ResponseFailureModel.self, from: data)
                let errorMessage = StringError(errorModel.status)
                throw HeroError.parsingError(errorMessage)
            }
        } catch let error as DecodingError {
            throw HeroError.parsingError(error)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw HeroError.noInternetConnection
            case .timedOut:
                throw HeroError.timeout
            default:
                print("request \(request)")
                throw HeroError.otherNetworkError(error)
            }
        } catch {
            print("request1 \(request)")
            throw HeroError.otherNetworkError(error)
        }
    }
    
//    func fetchHeroesData(from offset: Int, completion: @escaping (Result<Heroes, Error>) -> Void) {
//        let path = APIManager.shared.urlString(offset: offset, endpoint: .getHeroes)
//        let urlString = String(format: path)
//        
//        AF.request(urlString)
//            .validate()
//            .responseDecodable(of: ResponseModel<HeroItemModel>.self, queue: .global(), decoder: JSONDecoder()) { (response) in
//                switch response.result {
//                case .success(let heroesData):
//                    completion(.success(heroesData.data.results))
//                    break
//                case .failure(let error):
//                    
//                    if let err = self.getHeroError(error: error, data: response.data) {
//                        completion(.failure(err))
//                    } else {
//                        completion(.failure(error))
//                    }
//                    
//                    break
//                }
//            }
//    }
    
//    func fetchHeroData(heroItem: HeroRO, completion: @escaping (Result<HeroItemModel, Error>) -> Void) {
//        let path = "\(APIType.getHero.request)/\(heroItem.id)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
//        let urlString = String(format: path)
//        
//        AF.request(urlString)
//            .validate()
//            .responseDecodable(of: ResponseModel<HeroItemModel>.self, queue: .global(), decoder: JSONDecoder()) { (response) in
//                switch response.result {
//                case .success(let heroesData):
//                    let model = heroesData.data.results.first ?? mockUpHeroData
//                    completion(.success(model))
//                    break
//                case .failure(let error):
//                    if let err = self.getHeroError(error: error, data: response.data) {
//                        completion(.failure(err))
//                    } else {
//                        completion(.failure(error))
//                    }
//                    break
//                }
//            }
//    }
    
    @MainActor func getImageForHero(url: String, imageView: UIImageView) {
        do {
            let realm = try Realm()
            let cachedImage = realm.objects(CachedImageData.self).filter { $0.url == url }.first
            
            if let cachedImage = cachedImage, let imageData = cachedImage.imageData, let image = UIImage(data: imageData) {
                imageView.image = image
                return
            }
        } catch {
            print("Error saving image to Realm cache: \(error)")
            imageView.image = MockUpImage
        }
        
        // if image isn't cached
        getImageForHeroFromNet(url: url, imageView: imageView)
    }
    
    // MARK: - private func
    
    @MainActor private func getImageForHeroFromNet(url: String, imageView: UIImageView) {
        let url = URL(string: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        let indicatorStyle = UIActivityIndicatorView.Style.large
        let indicator = UIActivityIndicatorView(style: indicatorStyle)
        
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        imageView.kf.setImage(with: url, options: [.processor(processor), .transition(.fade(0.2))]){ result in
            switch result {
            case .success(let imageResult):
                imageView.image = imageResult.image
                
                let cachedImageData = CachedImageData(
                    url: url?.absoluteString ?? "",
                    imageData: imageResult.image.pngData()
                )
                
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        realm.add(cachedImageData, update: .modified)
                    }
                    print("Downloaded and cached image for \(String(describing: url))")
                } catch {
                    print("Error saving image to Realm cache: \(error)")
                }
                break
            case .failure(let error):
                imageView.image = MockUpImage
                print("Error loading image: \(error)")
                
                DispatchQueue.main.async {
                    LoadingIndicator.stopLoading()
                }
                break
            }
        }
    }
    
    private func getHeroError(error: AFError, data: Data?) -> Error? {
        if let data = data,
           let failure = try? JSONDecoder().decode(ResponseFailureModel.self, from: data) {
            let message = StringError(failure.status)
            return HeroError.otherNetworkError(message)
        } else {
            return nil
        }
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

final class APIMockManager: ApiServiceProtocol {
    func performRequest<T>(from urlString: String, modelType: T.Type) async throws -> T where T : Decodable {
        return try await makeHTTPRequest(for: URLRequest(url: URL(string: urlString)!), codableModelType: ResponseModel<HeroItemModel>.self) as! T
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

struct StringError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension StringError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
