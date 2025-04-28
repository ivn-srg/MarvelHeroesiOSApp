//
//  APIManager.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.04.2024.
//

import Foundation
import CryptoKit
import RealmSwift
import UIKit

final class APIManager: ApiServiceProtocol {
    public static let shared = APIManager()
    
    private var currentTimeStamp: Int {
        Int(Date().timeIntervalSince1970)
    }
    
    private var md5Hash: String {
        MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
    }
    
    func composeURL(for method: API.Endpoint, urlComponents: [String?]?, queryItems: [API.QueryParams: Int?]? = nil) -> URL? {
        
        let authString = "?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        var finalURLString = ""
        
        switch method {
        case .clearlyURL(let clearlyUrl):
            finalURLString = clearlyUrl
            
        case .finalURL(let finalUrl):
            finalURLString = "\(finalUrl)\(authString)"
            
        default:
            finalURLString = "\(method.fullURL)\(authString)"
        }
        
        var resultUrl = URL(string: finalURLString)
        
        if let urlComponents = urlComponents {
            for component in urlComponents {
                guard let component = component else { continue }
                
                resultUrl = resultUrl?.appendingPathComponent(component)
            }
        }
        
        if let queryItems = queryItems {
            var queryDict = [URLQueryItem]()
            
            for item in queryItems {
                guard let itemValue = item.value else { continue }
                
                queryDict.append(URLQueryItem(name: item.key.rawValue, value: "\(itemValue)"))
            }
            
            resultUrl?.append(queryItems: queryDict)
        }
        
        return resultUrl
    }
    
    func performRequest<T: Decodable>(
        from url: URL?,
        modelType: T.Type
    ) async throws -> T {
        guard let url else { throw API.HeroError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.Method.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        return try await makeHTTPRequest(for: request, codableModelType: modelType)
    }
    
    func makeHTTPRequest<T: Decodable>(
        for request: URLRequest,
        codableModelType: T.Type
    ) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard data != notFoundEntityResponseData else { throw API.HeroError.notFoundEntity }
            
            do {
                let result = try JSONDecoder().decode(codableModelType, from: data)
                return result
            } catch {
                print("data = \(String(decoding: data, as: UTF8.self))")
                let errorModel = try JSONDecoder().decode(ResponseFailureModel.self, from: data)
                let errorMessage = StringError(errorModel.message ?? errorModel.status ?? "Error".localized)
                throw API.HeroError.parsingFailureModelError(errorMessage)
            }
        } catch let error as DecodingError {
            throw API.HeroError.parsingError(error)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw API.HeroError.noInternetConnection
            case .timedOut:
                throw API.HeroError.timeout
            default:
                throw API.HeroError.otherNetworkError(error)
            }
        } catch {
            guard let error = error as? API.HeroError else {
                throw API.HeroError.otherNetworkError(error)
            }
            
            throw error
        }
    }
    
    // MARK: - getting Image funcs
    func getImage(url: String) async throws -> UIImage {
        if url == "entity.mock" {
            return emptyEntityImage
        } else if url == "hero.mock" || url == "\(imageNotAvailable).jpg" {
            return MockUpImage
        }
        
        if let cachedImage = await RealmManager.shared.fetchCachedImage(url: url),
           let imageData = cachedImage.imageData,
           let image = UIImage(data: imageData) {
            return image
        }
        
        // if image isn't cached
        return try await getImageForHeroFromNet(url: url)
    }
    
    private func getImageForHeroFromNet(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw API.HeroError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                throw API.HeroError.cashingFailed("Error saving image to Realm cache: \(error)".errorString)
            }
            return uiImage
        } else {
            print("Error loading image: \(url)")
            return emptyEntityImage
        }
    }
    
    // MARK: - private utility func
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
