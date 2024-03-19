//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher

class DetailHeroViewController: UIViewController {
    
    // MARK: - Fields
    
    let viewModel: DetailHeroViewModel
    var hero: HeroModel
    
    // MARK: - UI Components
    
    private lazy var box: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var backButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "arrow.left")
        configuration.baseForegroundColor = .white
        configuration.buttonSize = .small
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    private lazy var heroNameText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 34)
        txt.textColor = .white
        return txt
    }()
    
    private lazy var heroInfoText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 24)
        txt.textColor = .white
        txt.numberOfLines = 3
        return txt
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
    
    init(hero: HeroModel) {
        self.hero = hero
        self.viewModel = DetailHeroViewModel(hero: hero)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - private functions
    
    private func setupView() {

        box.backgroundColor = bgColor
        
        viewModel.getImageFromNet(imageView: heroImageView)
        
        heroNameText.text = viewModel.heroItem.name
        heroInfoText.text = viewModel.heroItem.info
        
        view.addSubview(box)
        box.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        box.addSubview(heroImageView)
        heroImageView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(box.snp.top)
            make.bottom.equalTo(box.snp.bottom)
            make.leading.equalTo(box.snp.leading)
            make.trailing.equalTo(box.snp.trailing)
        }
        
        box.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.box.snp.top)
            make.leading.equalTo(self.box.snp.leading)
        }
        
        box.addSubview(heroInfoText)
        heroInfoText.snp.makeConstraints { make in
            make.bottom.equalTo(box.snp.bottom).offset(-30)
            make.leading.equalTo(box.snp.leading).offset(20)
            make.trailing.equalTo(box.snp.trailing).offset(-20)
        }
        
        box.addSubview(heroNameText)
        heroNameText.snp.makeConstraints { make in
            make.bottom.equalTo(heroInfoText.snp.top).offset(-8)
            make.leading.equalTo(heroInfoText.snp.leading)
            make.trailing.equalTo(heroInfoText.snp.trailing)
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}