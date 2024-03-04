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
        iv.image = QuestionImage
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
            make.width.equalTo(self.snp.width)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        self.addSubview(nameOfHero)
        nameOfHero.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-40)
            make.leading.equalTo(self.snp.leading).offset(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
