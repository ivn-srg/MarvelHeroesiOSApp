//
//  DetailHeroViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher
import Alamofire
import CryptoKit

final class DetailHeroViewModel {
    
    var heroItem: HeroModel
    let currentTimeStamp = Int(Date().timeIntervalSince1970)
    
    init(hero: HeroModel) {
        self.heroItem = hero
    }
    
    // MARK: - Network work
    
    func fetchHeroData(completion: @escaping (Result<ResponseModel, Error>) -> Void) {
            let md5Hash = MD5(string: "\(currentTimeStamp)\(PRIVATE_KEY)\(API_KEY)")
        let path = "\(BASE_URL)/v1/public/characters/\(heroItem.id)?ts=\(currentTimeStamp)&apikey=\(API_KEY)&hash=\(md5Hash)"
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
                    self.heroItem = model.data.results.first ?? mockUpHeroData
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

    func getImageFromNet(imageView: UIImageView) {
        
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
                print("average color: \(self.getAverageColorOfImage(image: imageView.image))")
                break
            case .failure(let error):
                imageView.image = MockUpImage
                print("Error loading image: \(error)")
                break
            }
        }
    }
    
    func getAverageColorOfImage(image: UIImage?) -> UIColor {
        guard let image = image, let avgColoer = image.averageColor() else { return .systemBlue }
        
        return avgColoer
    }
}
