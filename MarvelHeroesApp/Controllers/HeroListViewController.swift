//
//  ViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 29.02.2024.
//

import UIKit
import SnapKit

class HeroListViewController: UIViewController {
    
    // MARK: - Fields
    
    private let viewModel: HeroListViewModel
    
    private var itemW: CGFloat {
        screenWidth * 0.7
    }
    
    private var itemH: CGFloat {
        itemW * 1.67
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
        lt.minimumLineSpacing = 50
        return lt
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 55)
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var triangleView: TriangleView = {
        let tv = TriangleView(
            colorOfTriangle: viewModel.dataSource[0].color,
            frame: RectForTriagle)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if customLayout.currentPage == 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                transformCell(cell)
            }
        }
    }
    
    // MARK: - private functions
    
    private func setupUI() {
        
        box.backgroundColor = bgColor
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        marvelLogo.image = Logo
        
        chooseHeroText.text = mainScreenTitle
        
        view.addSubview(box)
        box.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        triangleView.backgroundColor = .clear
        box.addSubview(triangleView)
        triangleView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.box.snp.top).offset(self.view.frame.height * 0.25)
            make.leading.equalTo(self.box.snp.leading)
            make.trailing.equalTo(self.box.snp.trailing)
            make.bottom.equalTo(self.box.snp.bottom)
        }
        
        box.addSubview(marvelLogo)
        marvelLogo.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.box.snp.top).offset(25)
            make.width.equalTo(self.box.snp.width).multipliedBy(0.4)
            make.height.equalTo(self.box.snp.height).multipliedBy(0.04)
            make.centerX.equalTo(self.box.snp.centerX)
        }
        
        box.addSubview(chooseHeroText)
        chooseHeroText.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.marvelLogo.snp.bottom).offset(30)
            make.width.equalTo(self.box.snp.width)
        }
        
        box.addSubview(collectionView)
        collectionView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(chooseHeroText.snp.bottom)
            make.width.equalTo(box.snp.width)
            make.bottom.equalTo(box.snp.bottom)
        }
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
        cell.configure(with: hero)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hero = viewModel.dataSource[indexPath.row]
        
        if indexPath.item == customLayout.currentPage {
            let vc = DetailHeroViewController(hero: hero)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemW, height: itemH)
    }
}

extension HeroListViewController {

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setupCell()
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: customLayout.currentPage, section: 0)
        let hero = viewModel.dataSource[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        triangleView.colorOfTriangle = hero.color
        triangleView.setNeedsDisplay()
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
