//
//  DetailHeroBottomSubview.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 06.11.2024.
//

import UIKit

final class DetailHeroBottomSubview: UIView {
    // MARK: - Fields
    
    
    // MARK: - UI components
    private lazy var topSwipeIcon: UIImageView = {
        let minus = UIImageView(image: minusImage)
        minus.contentMode = .scaleAspectFill
        minus.tintColor = .lightGray
        return minus
    }()
    
    private lazy var comicsCollectionView: UICollectionView = {
        let ccv = UICollectionView()
//        ccv.register(ComicsCollectionViewCell.self, forCellWithReuseIdentifier: ComicsCollectionViewCell.reuseIdentifier)
        return ccv
    }()
    
    // MARK: - Lyfecycle
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        backgroundColor = bgColor
        layer.cornerRadius = 25
        
        addSubview(topSwipeIcon)
        topSwipeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
}
