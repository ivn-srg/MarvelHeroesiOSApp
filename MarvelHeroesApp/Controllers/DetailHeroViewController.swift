//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import SnapKit

final class DetailHeroViewController: UIViewController, UIScrollViewDelegate {
    
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
        configuration.image?.applyingSymbolConfiguration(.init(weight: .medium))
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
    
    private lazy var viewWithDetailInfo: UIView = {
        let view = UIView()
        view.backgroundColor = bgColor
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let overlapThreshold: CGFloat = 0.4
    // Приведем начальное положение
    private var viewWithDetailInfoTopConstraint: NSLayoutConstraint!
    
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
        executeWithErrorHandling {
            try viewModel.fetchHeroData()
        }
        updateView()
    }
    
    // MARK: - UI Setup
    private func setupView() {
        view.addSubview(box)
        box.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.frame.height * 0.9)
        }
        
        box.addSubview(heroImageView)
        heroImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        box.addSubview(backButton)
        backButton.snp.makeConstraints { $0.top.leading.equalToSuperview() }
        
        box.addSubview(heroInfoText)
        heroInfoText.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        box.addSubview(heroNameText)
        heroNameText.snp.makeConstraints {
            $0.bottom.equalTo(heroInfoText.snp.top).offset(-10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(viewWithDetailInfo)
        
        // Устанавливаем начальное положение viewWithDetailInfo
        viewWithDetailInfo.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        viewWithDetailInfoTopConstraint = viewWithDetailInfo.topAnchor.constraint(equalTo: box.bottomAnchor, constant: -40)
        viewWithDetailInfoTopConstraint.isActive = true
        
        // Добавляем распознаватель жестов для перетаскивания
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        viewWithDetailInfo.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Update View
    private func updateView() {
        if let imgLink = viewModel.heroItem.thumbnail {
            let url = "\(imgLink.path).\(imgLink.thumbnailExtension)"
            viewModel.getHeroImage(from: url, to: heroImageView)
        }
        
        heroNameText.text = viewModel.heroItem.name
        heroInfoText.text = viewModel.heroItem.heroDescription.isEmpty ? "Just a cool Marvel hero" : viewModel.heroItem.heroDescription
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Pan Gesture actions
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newTopConstant = max(viewWithDetailInfoTopConstraint.constant + translation.y, -view.frame.height * 0.9)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            viewWithDetailInfoTopConstraint.constant = newTopConstant
            gesture.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            if abs(velocity.y) > 1000 {
                if velocity.y < 0 {
                    animateViewToTop()
                } else {
                    animateViewToOriginalPosition()
                }
            } else {
                if abs(newTopConstant) > view.frame.height * 0.45 {
                    animateViewToTop()
                } else {
                    animateViewToOriginalPosition()
                }
            }
        default:
            break
        }
    }
    
    // Анимация к исходной позиции
    private func animateViewToOriginalPosition() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewWithDetailInfoTopConstraint.constant = -40
            self.view.layoutIfNeeded()
        })
    }
    
    // Анимация к верхней позиции
    private func animateViewToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewWithDetailInfoTopConstraint.constant = -self.view.frame.height * 0.9
            self.view.layoutIfNeeded()
        })
    }
}
