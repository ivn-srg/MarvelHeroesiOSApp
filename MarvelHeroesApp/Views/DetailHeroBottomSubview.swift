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
    private var navControl: UINavigationController?
    private var startScrollPosition: CGFloat?
    
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
        view.spacing = 20
        return view
    }()
    
    private lazy var heroBrowseView = TextBlockWithTitleView(
        title: "Overview".localized,
        text: viewModel.heroItem.heroDescription.isEmpty ? heroDescriptionMock : viewModel.heroItem.heroDescription
    )
    
    private lazy var comicsCollectionView: CustomHorizontalCollectionView = {
        let view = CustomHorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionType = .comics
        return view
    }()
    
    private lazy var seriesCollectionView: CustomHorizontalCollectionView = {
        let view = CustomHorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionType = .series
        return view
    }()
    
    private lazy var storiesCollectionView: CustomHorizontalCollectionView = {
        let view = CustomHorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionType = .stories
        return view
    }()
    
    private lazy var eventsCollectionView: CustomHorizontalCollectionView = {
        let view = CustomHorizontalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionType = .events
        return view
    }()
    
    private lazy var buttonStackView: StackWithButtonsView = {
        let view = StackWithButtonsView(
            navigationController: self.navControl,
            listOfURLs: Array(viewModel.heroItem.urls)
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var currentViewTopConstraint: NSLayoutConstraint!
    
//    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    
    // MARK: - Lyfecycle
    init(navigationController: UINavigationController?, vm: DetailHeroViewModel) {
        self.viewModel = vm
        self.navControl = navigationController
        super.init(frame: .zero)
        
        comicsCollectionView.update(with: viewModel.heroItem.comics)
        seriesCollectionView.update(with: viewModel.heroItem.series)
        storiesCollectionView.update(with: viewModel.heroItem.stories)
        eventsCollectionView.update(with: viewModel.heroItem.events)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func configureView() {
        backgroundColor = UIColor.bgColor
        layer.maskedCorners = .init(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        layer.cornerRadius = 25
        
        addSubview(topSwipeIcon)
        topSwipeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.width.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topSwipeIcon.snp.bottom).offset(10)
            $0.bottomMargin.equalTo(safeAreaLayoutGuide.snp.bottomMargin)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.horizontalEdges.width.centerX.bottomMargin.equalToSuperview()
        }
        
        stackView.addArrangedSubview(heroBrowseView)
        
        comicsCollectionView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        stackView.addArrangedSubview(comicsCollectionView)
        
        seriesCollectionView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        stackView.addArrangedSubview(seriesCollectionView)
        
        storiesCollectionView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        stackView.addArrangedSubview(storiesCollectionView)
        
        eventsCollectionView.snp.makeConstraints {
            $0.height.equalTo(450)
        }
        stackView.addArrangedSubview(eventsCollectionView)
        stackView.addArrangedSubview(buttonStackView)
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
        if startScrollPosition == nil { startScrollPosition = currentViewTopConstraint.constant }
        guard let startScrollPosition = startScrollPosition else { return }
        
        var offsetFromStartPosition: CGFloat {
            currentViewTopConstraint.constant - scrollView.contentOffset.y
        }
        var diffStartAndOffset: CGFloat {
            abs(startScrollPosition - offsetFromStartPosition)
        }
        
        if scrollView.contentOffset.y <= 0 && !scrollView.isDecelerating {
            print("abs(startPosition - offsetFromStartPosition) \(diffStartAndOffset)")
            print("transition \(scrollView.contentOffset.y)")
            currentViewTopConstraint.constant = offsetFromStartPosition
            
            if diffStartAndOffset > screenHeight / 6 {
                guard let superView = navControl?.viewControllers.last as? DetailHeroViewController else { return }
                superView.animateViewToOriginalPosition()
            }
        }
    }
}
