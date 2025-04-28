//
//  APIInterface.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 29.04.2025.
//

import Foundation
import UIKit

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

protocol ApiServiceProtocol: AnyObject {
    func performRequest<T: Decodable>(
        from url: URL?,
        modelType: T.Type
    ) async throws -> T
    
    func makeHTTPRequest<T: Decodable>(
        for request: URLRequest,
        codableModelType: T.Type
    ) async throws -> T
    
    func getImage(url: String) async throws -> UIImage
    
    func composeURL(for method: API.Endpoint, urlComponents: [String?]?, queryItems: [API.QueryParams: Int?]?) -> URL?
}

struct API {
    
    static let baseURL = "https://gateway.marvel.com/v1/public/"
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum Endpoint {
        case getHeroes, getHero, getComics, getOneComics, getSeries, getOneSeries,
             getStories, getStory, getCreators, getCreator, getEvents, getEvent,
             finalURL(String), clearlyURL(String)
        
        private var endpoint: String {
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
        
        var fullURL: String {
            "\(baseURL)\(endpoint)"
        }
    }
    
    enum HeroError: Error, LocalizedError {
        case invalidURL, parsingError(Error), serializationError(Error), noInternetConnection,
             timeout, otherNetworkError(Error), notFoundEntity, cashingFailed(Error),
             unexpectedData, parsingFailureModelError(Error)
    }
    
    enum QueryParams: String {
        case limit = "limit"
        case offset = "offset"
        case timestamp = "ts"
        case apiKey = "apikey"
        case hash = "hash"
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
