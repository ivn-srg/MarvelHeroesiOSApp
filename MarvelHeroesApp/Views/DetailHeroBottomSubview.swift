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
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    private lazy var heroBrowseView = TextBlockWithTitleViewTests(
        title: "Overview".localized,
        text: viewModel.heroItem.heroDescription.isEmpty ? heroDescriptionMock : viewModel.heroItem.heroDescription
    )
    
    private lazy var comicsCollectionView: UICollectionView = {
        let ccv = UICollectionView()
        ccv.translatesAutoresizingMaskIntoConstraints = false
        ccv.register(ComicsCollectionViewCell.self, forCellWithReuseIdentifier: ComicsCollectionViewCell.identifier)
        ccv.delegate = self
        ccv.dataSource = self
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
            $0.edges.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(heroBrowseView)
        heroBrowseView.snp.makeConstraints {
            $0.top.equalTo(topSwipeIcon.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        addSubview(comicsCollectionView)
        comicsCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - public funcs
    func hideTopSwipeIcon(_ value: Bool = true) {
        UIView.animate(withDuration: 0.2) {
            self.topSwipeIcon.isHidden = value
        }
    }
}

extension DetailHeroBottomSubview: UICollectionViewDelegate {
    
}

extension DetailHeroBottomSubview: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.heroItem.comics?.available ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ComicsCollectionViewCell.identifier,
                for: indexPath
            ) as? ComicsCollectionViewCell
        else { return UICollectionViewCell() }
        
        let comics = viewModel.heroItem.comics?.items[indexPath.row]
        
        cell.configure(comics: comics)
        
        return cell
    }
    
    
}
