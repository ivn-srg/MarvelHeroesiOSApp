//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher

class DetailHeroViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    private lazy var panRecognize = UIPanGestureRecognizer(target: self, action: #selector(pull2refresh))
    
    // MARK: - Lifecycle
    
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
        
        fetchHeroesData()
    }
    
    // MARK: - UI functions
    
    private func setupView() {
        
        view.addGestureRecognizer(panRecognize)

//        box.backgroundColor = bgColor
        
        viewModel.getImageFromNet(imageView: heroImageView)
        
        heroNameText.text = viewModel.heroItem.name
        heroInfoText.text = viewModel.heroItem.description == "" ? "Empty" : viewModel.heroItem.description
        
        view.addSubview(box)
        box.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentInset = UIEdgeInsets(top: 40 - scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Network func
    
    private func fetchHeroesData() {
        LoadingIndicator.startLoading()
        
        viewModel.fetchHeroData() { [weak self] (result) in
            guard let this = self else { return }
            this.handleResult(result)
            self?.setupView()
        }
    }
    
    private func handleResult(_ result: Result<ResponseModel, Error>) {
        switch result {
        case .success:
            LoadingIndicator.stopLoading()
        case .failure(let error):
            LoadingIndicator.stopLoading()
            print(error)
        }
    }
    
    // MARK: - @objc func
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func pull2refresh(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        // Смещаем экран по вертикали на значение смещения жеста
        view.frame.origin.y = max(translation.y, 0)
        
        if gesture.state == .ended {
            // Если жест закончился, возвращаем экран в исходное положение
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
            
            print("swipe")
            fetchHeroesData()
            setupView()
        }
    }
}
