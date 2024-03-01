//
//  HeroCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier = "CollectionViewCellId"
    
    // MARK: - UI components
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var nameOfHero: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 30, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: - Functions
    
    public func configure(with hero: HeroModel) {
        self.imageView.image = UIImage(named: hero.imageName)
        self.nameOfHero.text = hero.name
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        self.addSubview(nameOfHero)
        nameOfHero.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-30)
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
