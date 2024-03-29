//
//  HeroCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import UIKit
import Kingfisher

protocol MyCellDelegate: AnyObject {
    func changeTriangleViewColor(color: UIColor)
}

class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier = "CollectionViewCellId"
    var heroImage: UIImage = UIImage()
    weak var delegate: MyCellDelegate?
    
    // MARK: - UI components
    
    private lazy var heroImageView: UIImageView = {
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
        lbl.numberOfLines = 2
        return lbl
    }()
    
    // MARK: - Functions
    
    public func configure(viewModel: HeroCollectionViewCellViewModel) {
        self.nameOfHero.text = viewModel.heroName
        viewModel.getImageFromNet(imageView: heroImageView)
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(heroImageView)
        heroImageView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        self.addSubview(nameOfHero)
        nameOfHero.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-30)
            make.leading.equalTo(self.snp.leading).offset(25)
            make.trailing.equalTo(self.snp.trailing).offset(-25)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.heroImageView.image = nil
        self.nameOfHero.text = nil
    }
}
