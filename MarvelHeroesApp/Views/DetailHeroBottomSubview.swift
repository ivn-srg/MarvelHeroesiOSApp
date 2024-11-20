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
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.delegate = self
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private lazy var heroBrowseView = TextBlockWithTitleView(
        title: "Overview".localized,
        text: viewModel.heroItem.heroDescription.isEmpty ? heroDescriptionMock : viewModel.heroItem.heroDescription
    )
    
    private let comicsCollectionView: CustomHorizontalCollectionView = {
        let view = CustomHorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionType = .comics
        return view
    }()
    
//    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    
    // MARK: - Lyfecycle
    init(vm: DetailHeroViewModel) {
        self.viewModel = vm
        super.init(frame: .zero)
        
        if let comicsData = viewModel.heroItem.comics {
            comicsCollectionView.update(with: comicsData.items)
        } else {
            let sampleData = mockUpListData
            mockUpListData.insert(contentsOf: Array(repeating: ComicsItemRO(), count: 5), at: 0)
            comicsCollectionView.update(with: sampleData)
        }
        
//        addGestureRecognizer(panGesture)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func configureView() {
        backgroundColor = bgColor
        layer.maskedCorners = .init(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        layer.cornerRadius = 25
        
        addSubview(topSwipeIcon)
        topSwipeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(scrollView)
        let scrollableContentSize = CGSize(width: frame.width, height: frame.height - topSwipeIcon.frame.height)
        scrollView.contentSize = scrollableContentSize
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topSwipeIcon.snp.bottom).offset(10)
            $0.horizontalEdges.bottomMargin.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(horizontalPadding)
            $0.width.equalToSuperview().inset(horizontalPadding)
            $0.centerX.equalToSuperview()
        }
        
        stackView.addArrangedSubview(heroBrowseView)
        
        comicsCollectionView.snp.makeConstraints {
            $0.height.equalTo(250)
        }
        stackView.addArrangedSubview(comicsCollectionView)
        
        
//        scrollView.addSubview(heroBrowseView)
//        heroBrowseView.snp.makeConstraints {
//            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
//            $0.horizontalEdges.equalTo(scrollView.contentLayoutGuide.snp.horizontalEdges)
//            $0.width.equalToSuperview().inset(horizontalPadding)
//        }
//        
//        scrollView.addSubview(comicsCollectionView)
//        comicsCollectionView.snp.makeConstraints {
//            $0.top.equalTo(heroBrowseView.snp.bottom).offset(10)
//            $0.horizontalEdges.equalTo(scrollView.contentLayoutGuide.snp.horizontalEdges)
//            $0.width.equalToSuperview().inset(horizontalPadding)
//            $0.height.equalTo(200)
//        }
    }
    
    // MARK: - public funcs
    func hideTopSwipeIcon(_ value: Bool = true) {
        UIView.animate(withDuration: 0.2) {
            self.topSwipeIcon.isHidden = value
        }
    }
}

extension DetailHeroBottomSubview: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
