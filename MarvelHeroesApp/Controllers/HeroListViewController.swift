//
//  ViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 29.02.2024.
//

import UIKit
import SnapKit

final class HeroListViewController: UIViewController {
    
    // MARK: - Fields
    
    private let viewModel: HeroListViewModel
    
    private var itemW: CGFloat {
        screenWidth * 0.7
    }
    
    private var itemH: CGFloat {
        screenHeight * 0.6
    }
    
    // MARK: - UI components
    
    private lazy var box: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var marvelLogo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    private lazy var chooseHeroText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 28)
        txt.textColor = .white
        txt.textAlignment = .center
        txt.numberOfLines = 2
        return txt
    }()
    
    private lazy var customLayout: CustomHeroItemLayer = {
        let lt = CustomHeroItemLayer()
        lt.itemSize.width = itemW
        lt.scrollDirection = .horizontal
        lt.minimumLineSpacing = itemW * 0.18
        return lt
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: itemW * 0.25, bottom: 0, right: itemW * 0.25)
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.accessibilityIdentifier = "heroCollection"
        return collectionView
    }()
    
    private lazy var triangleView: TriangleView = {
        let tv = TriangleView(frame: view.bounds)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.accessibilityIdentifier = "triangleView"
        return tv
    }()
    
    private lazy var panRecognize: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(pull2refresh))
        return gestureRecognizer
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.loaderColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - lifecycle
    
    init(vm: HeroListViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        executeWithErrorHandling {
            try viewModel.fetchHeroesData(into: collectionView)
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: - UI functions
    
    private func setupUI() {
        
        box.backgroundColor = UIColor.bgColor
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        marvelLogo.image = Logo
        
        chooseHeroText.text = mainScreenTitle
        
        view.addGestureRecognizer(panRecognize)
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.05)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        view.addSubview(box)
        box.snp.makeConstraints{
            $0.verticalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.verticalEdges)
            $0.horizontalEdges.equalToSuperview()
        }
        
        triangleView.backgroundColor = .clear
        box.addSubview(triangleView)
        triangleView.snp.makeConstraints{
            $0.top.equalTo(self.box.snp.top).offset(self.view.frame.height * 0.25)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
        box.addSubview(marvelLogo)
        marvelLogo.snp.makeConstraints{
            $0.top.equalTo(self.box.snp.top).offset(20)
            $0.width.equalTo(self.box.snp.width).multipliedBy(0.4)
            $0.height.equalTo(self.box.snp.height).multipliedBy(0.09)
            $0.centerX.equalToSuperview()
        }
        
        box.addSubview(chooseHeroText)
        chooseHeroText.snp.makeConstraints{
            $0.top.equalTo(self.marvelLogo.snp.bottom).offset(20)
            $0.width.equalToSuperview()
        }
        
        box.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(chooseHeroText.snp.bottom)
            $0.bottom.width.equalToSuperview()
        }
    }
    
    private func moveFocusOnItem() {
        let itemCount = collectionView.numberOfItems(inSection: 0)
        var (currentPage, _) = UDManager.shared.getCurrentPosition()
        currentPage = currentPage > itemCount ? itemCount - 1 : currentPage
        
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        setupCell()
    }
    
    @objc func pull2refresh(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: box)
        let newY = max(translation.y, 0)
        let maxPullDownDistance = self.box.frame.height * 0.2
        
        if newY <= maxPullDownDistance {
            box.transform = CGAffineTransform(translationX: 0, y: newY)
        }
        
        if gesture.state == .began {
            activityIndicator.startAnimating()
        }
        
        if gesture.state == .ended {
            if newY > maxPullDownDistance {
                executeWithErrorHandling {
                    try viewModel.fetchHeroesData(into: collectionView, needRefresh: true)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.box.transform = CGAffineTransform.identity
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func updateTriangleViewColor(didLoadImage: UIImage?) {
        guard let image = didLoadImage else { return }
        let averageColor = image.averageColor()
        triangleView.accessibilityLabel = averageColor.cgColor.toString()
        triangleView.updateTriangleColor(averageColor)
    }
}

// MARK: - Extensions

extension HeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.countOfRow()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        let hero = viewModel.dataSource[indexPath.row]
        
        cell.configure(viewModel: HeroCollectionViewCellViewModel(hero: HeroRO(heroData: hero)))
        
        moveFocusOnItem()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = viewModel.dataSource[indexPath.row]
        
        if indexPath.item == customLayout.currentPage {
            let vc = DetailHeroViewController(hero: HeroRO(heroData: hero))
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            customLayout.currentPage = indexPath.item
            customLayout.previousOffset = customLayout.updateOffset(collectionView)
            setupCell()
        }
    }
}

extension HeroListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width * 0.7,
            height: collectionView.frame.height * 0.75
        )
    }
}

extension HeroListViewController {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setupCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == viewModel.countOfRow() - 1 {
            let totalRows = collectionView.numberOfItems(inSection: indexPath.section)
            
            if lastRow >= totalRows - 1 {
                if collectionView.contentOffset.x > 0 {
                    executeWithErrorHandling {
                        try viewModel.fetchHeroesData(into: collectionView, needsLoadMore: true)
                    }
                }
            }
        }
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: customLayout.currentPage, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeroCollectionViewCell else { return }

        updateTriangleViewColor(didLoadImage: cell.heroImage)
        transformCell(cell)
    }
    
    private func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true) {
        if !isEffect {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        for otherCell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: otherCell) {
                if indexPath.item != customLayout.currentPage {
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
    }
}
