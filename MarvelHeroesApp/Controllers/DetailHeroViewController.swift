//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit

class DetailHeroViewController: UIViewController {
    
    // MARK: - Fields
    
    let viewModel: DetailHeroViewModel
    var hero: HeroModel = HeroModel(name: "", info: "", imageName: "", color: 0, urlImage: "")
    
    // MARK: - UI Components
    
    private lazy var box: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    private lazy var heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        iv.image = QuestionImage
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
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
        txt.numberOfLines = 2
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
        
        // Установите прозрачность для панели навигации
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        box.backgroundColor = bgColor
        
        DispatchQueue.global().async {
            self.getImageFromNet(url: self.viewModel.heroItem.urlImage)
        }
        
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
        
        box.addSubview(heroInfoText)
        heroInfoText.snp.makeConstraints { make in
            make.bottom.equalTo(box.snp.bottom).offset(-20)
            make.leading.equalTo(box.snp.leading).offset(20)
        }
        
        box.addSubview(heroNameText)
        heroNameText.snp.makeConstraints { make in
            make.bottom.equalTo(heroInfoText.snp.top).offset(-8)
            make.leading.equalTo(heroInfoText.snp.leading)
        }
    }
    
    private func getImageFromNet(url: String) {
        
        viewModel.loadImageFromURL(urlString: url) { [weak self] data in
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image")
                return
            }
            DispatchQueue.main.async {
                self?.heroImageView.image = image
                self?.view.setNeedsDisplay()
            }
        }
    }
}
