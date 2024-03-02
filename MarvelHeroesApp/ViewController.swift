//
//  ViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 29.02.2024.
//

import UIKit
import SnapKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    //MARK: - Variables
    
    var itemW: CGFloat {
        screenWidth * 0.7
    }
    
    var itemH: CGFloat {
        itemW * 1.65
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
        txt.font = .systemFont(ofSize: 34, weight: .bold)
        txt.textColor = .white
        txt.textAlignment = .center
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

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        setupUI()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        customLayout.currentPage = indexPath.item
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            transformCell(cell)
        }
    }
    
    // MARK: - private functions

    private func setupUI() {
        
        box.backgroundColor = UIColor(rgb: 0x2b272b)
        
        marvelLogo.image = UIImage(named: "marvelLogo")
        
        chooseHeroText.text = "Choose your hero"
        
        view.addSubview(box)
        box.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        box.addSubview(marvelLogo)
        marvelLogo.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.box.snp.top).offset(25)
            make.centerX.equalTo(self.box.snp.centerX)
            make.width.equalTo(self.box.snp.width).multipliedBy(0.3)
            make.height.equalTo(35)
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ResponseModel.mockDataOfHeroes.result.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        
        let hero = ResponseModel.mockDataOfHeroes.result.entities[indexPath.row]
        cell.configure(with: hero)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == customLayout.currentPage {
            
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            customLayout.currentPage = indexPath.item
            customLayout.previosOffset = customLayout.updateOffset(collectionView)
            setupCell()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemW, height: itemH)
    }
}

extension ViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            setupCell()
        }
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: customLayout.currentPage, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)
        transformCell(cell!)
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
