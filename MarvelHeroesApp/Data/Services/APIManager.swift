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
    
    func getImage(url: String) async throws -> UIImage
    
    func urlString(endpoint: APIType, offset: Int?, entityId: Int?, finalURL: String?) throws -> String
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIType {
    case getHeroes, getHero, getComics, getOneComics, getSeries, getOneSeries,
         getStories, getStory, getCreators, getCreator, getEvents, getEvent,
         finalURL, clearlyURL
    
    private var baseURL: String {
        "https://gateway.marvel.com/v1/public/"
    }
    
    private var path: String {
        switch self {
        case .getHeroes, .getHero: "characters"
        case .getComics, .getOneComics: "comics"
        case .getSeries, .getOneSeries: "series"
        case .getStories, .getStory: "stories"
        case .getCreators, .getCreator: "creators"
        case .getEvents, .getEvent: "events"
        case .finalURL, .clearlyURL: ""
        }
    }
    
    var request: String {
        "\(baseURL)\(path)"
    }
}

enum HeroError: Error, LocalizedError {
    case invalidURL, parsingError(Error), serializationError(Error), noInternetConnection, timeout,
         otherNetworkError(Error), notFoundEntity, cashingFailed(Error), unexpectedData
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
    
    func urlString(endpoint: APIType, offset: Int? = nil, entityId: Int? = nil, finalURL: String? = nil) throws -> String {
        let limit = 30
        
        switch endpoint {
        case .getHeroes, .getComics, .getCreators, .getEvents, .getSeries, .getStories:
            guard let offset = offset else { throw HeroError.invalidURL }
            return "\(endpoint.request)?limit=\(limit)&offset=\(offset)&ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        case .getHero, .getEvent, .getStory, .getOneComics, .getOneSeries, .getCreator:
            guard let entityId = entityId else { throw HeroError.invalidURL }
            return "\(endpoint.request)/\(entityId)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        case .finalURL:
            guard let finalURL = finalURL else { throw HeroError.invalidURL }
            return "\(finalURL)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        case .clearlyURL:
            guard let finalURL = finalURL else { throw HeroError.invalidURL }
            return finalURL
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
    
    func makeHTTPRequest<T: Decodable>(
        for request: URLRequest,
        codableModelType: T.Type
    ) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard data != notFoundEntityResponseData else { throw HeroError.notFoundEntity }
//            print("data = \(String(decoding: data, as: UTF8.self))")
            do {
                let result = try JSONDecoder().decode(codableModelType, from: data)
                return result
            } catch {
                let errorModel = try JSONDecoder().decode(ResponseFailureModel.self, from: data)
                let errorMessage = StringError(errorModel.status)
                throw HeroError.parsingError(errorMessage)
            }
        } catch let error as DecodingError {
            print("request \(request)")
            throw HeroError.parsingError(error)
        } catch let error as URLError {
            print("request \(request)")
            switch error.code {
            case .notConnectedToInternet:
                throw HeroError.noInternetConnection
            case .timedOut:
                throw HeroError.timeout
            default:
                throw HeroError.otherNetworkError(error)
            }
        } catch {
            print("request1 \(request)")
            throw HeroError.otherNetworkError(error)
        }
    }
    
    // MARK: - getting Image funcs
    func getImage(url: String) async throws -> UIImage {
        if let cachedImage = await RealmManager.shared.fetchCachedImage(url: url),
            let imageData = cachedImage.imageData,
            let image = UIImage(data: imageData) {
            return image
        }
        
        // if image isn't cached
        return try await getImageForHeroFromNet(url: url)
    }
    
    private func getImageForHeroFromNet(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw HeroError.invalidURL }
        
        var request = try URLRequest(url: url, method: .get)
        request.allHTTPHeaderFields = ["Accept": "application/json,image/png,image/jpeg,image/gif"]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let uiImage = UIImage(data: data) {
            let cachedImageData = CachedImageData(
                url: url.absoluteString,
                imageData: data
            )
            
            do {
                try await MainActor.run {
                    let realm = try Realm()
                    
                    try realm.write {
                        realm.add(cachedImageData, update: .modified)
                    }
                }
            } catch {
                throw HeroError.cashingFailed("Error saving image to Realm cache: \(error)".errorString)
            }
            return uiImage
        } else {
            print("Error loading image: \(url)")
            return MockUpImage
        }
    }
    
    // MARK: - private utility func
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
