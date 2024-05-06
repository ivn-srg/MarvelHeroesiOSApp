//
//  HeroCollectionViewCellViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 28.03.2024.
//

import UIKit
import Kingfisher

final class HeroCollectionViewCellViewModel {
    
    let heroItem: HeroRO
    let heroImageUrlString: String
    
    init(hero: HeroRO) {
        self.heroItem = hero
        
        if let heroImageLink = hero.thumbnail {
            self.heroImageUrlString = "\(heroImageLink.path).\(heroImageLink.extension)"
        } else {
            self.heroImageUrlString = ""
        }
    }
}
