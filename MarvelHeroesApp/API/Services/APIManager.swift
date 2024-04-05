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

enum APIType {
    
    case getHeroes
    case getHero
    
    var baseURL: String {
        "https://gateway.marvel.com/v1/public/"
    }
    
    var path: String {
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

final class APIManager {
    
    static let shared = APIManager()
    var currentTimeStamp: Int {
        Int(Date().timeIntervalSince1970)
    }
    
    func fetchHeroesData(completion: @escaping (Result<Heroes, Error>) -> Void) {
        let md5Hash = MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
        let path = "\(APIType.getHeroes.request)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        let urlString = String(format: path)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ResponseModel.self, queue: .global(), decoder: JSONDecoder()) { (response) in
                switch response.result {
                case .success(let heroesData):
                    completion(.success(heroesData.data.results))
                    
                case .failure(let error):
                    print(error)
                    if let err = self.getHeroError(error: error, data: response.data) {
                        completion(.failure(err))
                    } else {
                        completion(.failure(error))
                    }
                    break
                }
            }
    }
    
    func fetchHeroData(heroItem: HeroModel, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        let md5Hash = MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
        let path = "\(APIType.getHero.request)/\(heroItem.id)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
        let urlString = String(format: path)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ResponseModel.self, queue: .global(), decoder: JSONDecoder()) { (response) in
                switch response.result {
                case .success(let heroesData):
                    let model = heroesData.data.results.first ?? mockUpHeroData
                    completion(.success(model))
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
    
    func getImageFromNet(heroItem: HeroModel, imageView: UIImageView) {
        
        let url = URL(string: "\(heroItem.thumbnail.path).\(heroItem.thumbnail.extension)")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        let indicatorStyle = UIActivityIndicatorView.Style.large
        let indicator = UIActivityIndicatorView(style: indicatorStyle)
        
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        
        imageView.kf.setImage(with: url, options: [.processor(processor), .transition(.fade(0.2))]){ result in
            switch result {
            case .success:
                break
            case .failure(let error):
                imageView.image = MockUpImage
                print("Error loading image: \(error)")
                break
            }
        }
    }
}
