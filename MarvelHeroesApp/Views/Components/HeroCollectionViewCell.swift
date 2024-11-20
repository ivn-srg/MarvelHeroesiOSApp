//
//  HeroCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import UIKit
import Kingfisher

final class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier = "CollectionViewCellId"
    var avgColorOfImage: UIColor = UIColor()
    var heroImage: UIImage = UIImage()
    var apiService = ApiServiceConfiguration.shared.apiService
    
    // MARK: - UI components
    
    private lazy var heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = MockUpImage
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private lazy var nameOfHero: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: Font.InterBold, size: 28)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.accessibilityIdentifier = "heroCellName"
        return lbl
    }()

    // MARK: - Lyfecycle
    
    deinit {
        heroImageView.removeObserver(self, forKeyPath: "image")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.heroImageView.image = nil
        self.nameOfHero.text = nil
    }
    
    // MARK: - Functions
    
    public func configure(viewModel: HeroCollectionViewCellViewModel) {
        setupUI()
        
        heroImageView.addObserver(self, forKeyPath: "image", options: [.new], context: nil)
        apiService.getImageForHero(url: viewModel.heroImageUrlString, imageView: heroImageView)
        
        nameOfHero.text = viewModel.heroItem.name
    }
    
    private func setupUI() {
        self.addSubview(heroImageView)
        heroImageView.snp.makeConstraints{
            $0.verticalEdges.width.equalToSuperview()
        }
        
        self.addSubview(nameOfHero)
        nameOfHero.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).offset(-30)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "image" {
            guard let img = heroImageView.image else { return }
            heroImage = img
        }
    }
}
