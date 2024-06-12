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

protocol ApiServiceProtocol: AnyObject {
    func fetchHeroesData(from offset: Int, completion: @escaping (Result<Heroes, Error>) -> Void)
    func fetchHeroData(heroItem: HeroRO, completion: @escaping (Result<HeroModel, Error>) -> Void)
    func getImageForHero(url: String, imageView: UIImageView)
}

enum APIType {
    
    case getHeroes
    case getHero
    
    private var baseURL: String {
        "https://gateway.marvel.com/v1/public/"
    }
    
    private var path: String {
        switch self {
        case .getHeroes: "characters"
        case .getHero: "characters"
        }
    }
    
    var request: String {
        "\(baseURL)\(path)"
    }
}

enum HeroError: Error, LocalizedError {
    
    case unknown
    case invalidURL
    case invalidUserData
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUserData:
            return "This is an invalid data. Please try again."
        case .invalidURL:
            return "Invalid url, man"
        case .unknown:
            return "Hey, this is an unknown error!"
        case .custom(let description):
            return description
        }
    }
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
    
    func fetchHeroesData(from offset: Int, completion: @escaping (Result<Heroes, Error>) -> Void) {
        let limit = 30
        let path = "\(APIType.getHeroes.request)?limit=\(limit)&offset=\(offset)&ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        let urlString = String(format: path)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ResponseModel.self, queue: .global(), decoder: JSONDecoder()) { (response) in
                switch response.result {
                case .success(let heroesData):
                    completion(.success(heroesData.data.results))
                    break
                case .failure(let error):
                    
                    if let err = self.getHeroError(error: error, data: response.data) {
                        completion(.failure(err))
                    } else {
                        completion(.failure(error))
                    }
                    
                    break
                }
            }
    }
    
    func fetchHeroData(heroItem: HeroRO, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        let path = "\(APIType.getHero.request)/\(heroItem.id)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        let urlString = String(format: path)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ResponseModel.self, queue: .global(), decoder: JSONDecoder()) { (response) in
                switch response.result {
                case .success(let heroesData):
                    let model = heroesData.data.results.first ?? mockUpHeroData
                    completion(.success(model))
                    break
                case .failure(let error):
                    print(error)
                    print(urlString)
                    if let err = self.getHeroError(error: error, data: response.data) {
                        completion(.failure(err))
                    } else {
                        completion(.failure(error))
                    }
                    break
                }
            }
    }
    
    func getImageForHero(url: String, imageView: UIImageView) {
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
    
    private func getImageForHeroFromNet(url: String, imageView: UIImageView) {
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
            let message = failure.message
            return HeroError.custom(description: message)
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
    
    public static let shared = APIMockManager()
    
    func fetchHeroesData(from offset: Int, completion: @escaping (Result<Heroes, any Error>) -> Void) {
        let response = [
            HeroModel(id: 1, name: "Deadpool", heroDescription: "This is the craziest hero in Marvel spacs!", thumbnail: ThumbnailModel(path: "Deadpool", extension: "")),
            HeroModel(id: 2, name: "Iron Man", heroDescription: "Robert is a clever guy", thumbnail: ThumbnailModel(path: "Iron Man", extension: ""))
        ]
        completion(.success(response))
    }
    
    func fetchHeroData(heroItem: HeroRO, completion: @escaping (Result<HeroModel, any Error>) -> Void) {
        let heroInfo = HeroModel(id: heroItem.id, name: heroItem.name, heroDescription: heroItem.heroDescription, thumbnail: ThumbnailModel(thumbRO: heroItem.thumbnail ?? ThumbnailRO()))
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
