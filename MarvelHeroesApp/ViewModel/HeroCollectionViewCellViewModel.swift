//
//  HeroCollectionViewCellViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 28.03.2024.
//

import UIKit
import Kingfisher

final class HeroCollectionViewCellViewModel {
    
    let heroItem: HeroModel
    let heroImageUrlString: String
    
    init(hero: HeroModel) {
        self.heroItem = hero
        self.heroImageUrlString = "\(hero.thumbnail.path).\(hero.thumbnail.extension)"
    }
}
