//
//  ViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 29.02.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.itemSize = CGSize(width: 400, height: 600)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = nil
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        return collectionView
    }()

    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        setupView()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func setupView() {
        
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
            make.bottom.equalTo(box.snp.bottom).offset(-30)
            
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
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
