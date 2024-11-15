//
//  DetailHeroBottomSubview.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 06.11.2024.
//

import UIKit

final class DetailHeroBottomSubview: UIView {
    // MARK: - Fields
    private var viewModel: DetailHeroViewModel
    
    // MARK: - UI components
    private lazy var topSwipeIcon: UIImageView = {
        let minus = UIImageView(image: minusImage)
        minus.translatesAutoresizingMaskIntoConstraints = false
        minus.contentMode = .scaleAspectFill
        minus.tintColor = .lightGray
        return minus
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var overviewTitle: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 34)
        txt.textColor = .white
        txt.text = "Overview"
        txt.numberOfLines = 1
        return txt
    }()
    
    private lazy var heroInfoText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterRegular, size: 24)
        txt.textColor = .white
        txt.numberOfLines = 0
        return txt
    }()
    
    private lazy var comicsCollectionView: UICollectionView = {
        let ccv = UICollectionView()
        ccv.translatesAutoresizingMaskIntoConstraints = false
//        ccv.register(ComicsCollectionViewCell.self, forCellWithReuseIdentifier: ComicsCollectionViewCell.reuseIdentifier)
        return ccv
    }()
    
    // MARK: - Lyfecycle
    init(vm: DetailHeroViewModel) {
        self.viewModel = vm
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func configureView() {
        backgroundColor = bgColor
        layer.cornerRadius = 25
        
        addSubview(topSwipeIcon)
        topSwipeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(topSwipeIcon.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(overviewTitle)
        stackView.addArrangedSubview(heroInfoText)
        
        heroInfoText.text = viewModel.heroItem.heroDescription.isEmpty ? heroDescriptionMock : viewModel.heroItem.heroDescription
    }
    
    // MARK: - public funcs
    func hideTopSwipeIcon(_ value: Bool = true) {
        UIView.animate(withDuration: 0.2) {
            self.topSwipeIcon.isHidden = value
        }
    }
}
