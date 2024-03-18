//
//  DetailHeroViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher

class DetailHeroViewModel {
    
    let heroItem: HeroModel
    
    init(hero: HeroModel) {
        self.heroItem = hero
    }
    
    // MARK: - Network work

    func getImageFromNet(imageView: UIImageView) {
        
        let url = URL(string: heroItem.urlImage)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        let indicatorStyle = UIActivityIndicatorView.Style.large
        let indicator = UIActivityIndicatorView(style: indicatorStyle)
        
        indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        imageView.kf.indicatorType = .activity
        (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white

        imageView.kf.setImage(with: url, options: [.processor(processor), .transition(.fade(0.2))]){ result in
            switch result {
            case .success:
                break
            case .failure(let error):
                if let image = UIImage(named: self.heroItem.imageName) {
                    imageView.image = image
                }
                print("Error loading image: \(error)")
                break
            }
        }

    }
        
    
    // MARK: - VC func
    
    
}
