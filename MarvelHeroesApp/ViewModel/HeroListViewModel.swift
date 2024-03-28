//
//  ListOfHeroesViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import Foundation
import Alamofire
import Kingfisher
import CryptoKit

enum HeroError: Error, LocalizedError {
    
    case unknown
    case invalidUserData
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUserData:
            return "This is an invalid data. Please try again."
        case .unknown:
            return "Hey, this is an unknown error!"
        case .custom(let description):
            return description
        }
    }
    
}

final class HeroListViewModel {
    
    var dataSource: [HeroModel] = []
    let currentTimeStamp = Int(Date().timeIntervalSince1970)
    
    init() {
        updateDataSource()
    }
    
    // MARK: - Network work
    
    func updateDataSource() {
        
    }
    
    func fetchHeroesData(completion: @escaping (Result<ResponseModel, Error>) -> Void) {
            let md5Hash = MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
            let path = "\(BASE_URL)/v1/public/characters?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
            let urlString = String(format: path)
            handleRequest(urlString: urlString, completion: completion)
        }
    
    private func handleRequest(urlString: String, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: ResponseModel.self, queue: .main, decoder: JSONDecoder()) { (response) in
                switch response.result {
                case .success(let heroesData):
                    let model = heroesData
                    completion(.success(model))
                    self.dataSource = model.data.results
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

    
    // MARK: - VC func
    
    func countOfRow() -> Int {
        dataSource.count
    }
}

