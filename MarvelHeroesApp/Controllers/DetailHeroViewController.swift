//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import Kingfisher

final class DetailHeroViewController: UIViewController {
    
    // MARK: - Fields
    
    let viewModel: DetailHeroViewModel
    
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
        button.accessibilityIdentifier = "backButton"
        return button
    }()
    
    private lazy var heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.image = MockUpImage
        return iv
    }()
    
    private lazy var heroNameText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 34)
        txt.textColor = .white
        txt.numberOfLines = 2
        txt.accessibilityIdentifier = "heroNameLabel"
        return txt
    }()
    
    private lazy var heroInfoText: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 24)
        txt.textColor = .white
        txt.numberOfLines = 3
        txt.accessibilityIdentifier = "heroInfoLabel"
        return txt
    }()
    
    private lazy var panRecognize: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(pull2refresh))
        return gestureRecognizer
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = loaderColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    init(hero: HeroRO) {
        self.viewModel = DetailHeroViewModel(hero: hero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewModel.fetchHeroData()
        self.updateView()
    }
    
    // MARK: - UI functions
    
    private func setupView() {
        
        view.addGestureRecognizer(panRecognize)
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.05)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
        }
        
        view.addSubview(box)
        box.snp.makeConstraints{
            $0.bottom.top.equalTo(self.view.safeAreaLayoutGuide.snp.verticalEdges)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        box.addSubview(heroImageView)
        heroImageView.snp.makeConstraints{
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        
        box.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        box.addSubview(heroInfoText)
        heroInfoText.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-30)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
        
        box.addSubview(heroNameText)
        heroNameText.snp.makeConstraints {
            $0.bottom.equalTo(heroInfoText.snp.top).offset(-8)
            $0.horizontalEdges.equalTo(heroInfoText.snp.horizontalEdges)
        }
    }
    
    private func updateView() {
        if let imgLink = viewModel.heroItem.thumbnail {
            let url = "\(imgLink.path).\(imgLink.extension)"
            viewModel.getHeroImage(from: url, to: heroImageView)
        }
        
        heroNameText.text = viewModel.heroItem.name
        heroInfoText.text = viewModel.heroItem.heroDescription == "" ? "Just a cool marvel hero" : viewModel.heroItem.heroDescription
    }
    
    // MARK: - @objc func
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
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
                viewModel.fetchHeroData()
                self.updateView()
            }
            UIView.animate(withDuration: 0.3) {
                self.box.transform = CGAffineTransform.identity
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
