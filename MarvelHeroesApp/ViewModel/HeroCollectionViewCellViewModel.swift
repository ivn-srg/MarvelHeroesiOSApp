//
//  HeroCollectionViewCellViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 28.03.2024.
//

import UIKit
import Kingfisher

final class HeroCollectionViewCellViewModel {
    
    let heroName: String
    let heroImageUrlString: String
    
    init(hero: HeroModel) {
        self.heroName = hero.name
        self.heroImageUrlString = "\(hero.thumbnail.path).\(hero.thumbnail.extension)"
    }
    
    // MARK: - Network func
    
    func getImageFromNet(imageView: UIImageView) {
        
        let url = URL(string: heroImageUrlString)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        let indicatorStyle = UIActivityIndicatorView.Style.large
        let indicator = UIActivityIndicatorView(style: indicatorStyle)
        
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white

        imageView.kf.setImage(with: url, options: [.processor(processor), .transition(.fade(0.2))]){ result in
            switch result {
            case .success:
                print("Loading image was success")
                
                break
            case .failure(let error):
                imageView.image = MockUpImage
                print("Error loading image: \(error)")
                break
            }
        }
    }
}
