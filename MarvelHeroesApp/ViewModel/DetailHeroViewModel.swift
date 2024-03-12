//
//  DetailHeroViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit

class DetailHeroViewModel {
    
    let heroItem: HeroModel
    
    init(hero: HeroModel) {
        self.heroItem = hero
    }
    
    // MARK: - Network work

    func loadImageFromURL(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }
        
    
    // MARK: - VC func
    
    
}
