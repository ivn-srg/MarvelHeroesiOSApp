//
//  DetailHeroViewModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher

final class DetailHeroViewModel {
    
    let heroItem: HeroModel
    
    init(hero: HeroModel) {
        self.heroItem = hero
    }
    
    // MARK: - Network work

    func getImageFromNet(imageView: UIImageView) {
        
        let url = URL(string: heroItem.thumbnail.path + heroItem.thumbnail.extension)
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
                imageView.image = QuestionImage
                print("Error loading image: \(error)")
                break
            }
        }

    }
        
    
    // MARK: - VC func
    
    func getAverageColorOfImage(image: UIImage?) -> UIColor {
        guard let image = image, let avgColoer = image.averageColor() else { return .systemBlue }
        
        return avgColoer
    }
}
