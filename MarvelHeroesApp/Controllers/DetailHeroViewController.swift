//
//  DetailHeroViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.03.2024.
//

import UIKit
import SnapKit

final class DetailHeroViewController: UIViewController {
    
    // MARK: - Fields
    let viewModel: DetailHeroViewModel
    private let detailModalOverlapValue = 0.9
    private let lowestDetailInfoYPositionConstant: Double = -30
    
    private var verticalSafeAreaInsets: Double {
        view.safeAreaInsets.top + view.safeAreaInsets.bottom
    }
    
    private var highestSafeeAreaYPosition: Double {
        verticalSafeAreaInsets - lowestDetailInfoYPositionConstant - view.frame.maxY
    }
    
    // MARK: - UI Components
    private lazy var box: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private lazy var upperAlphaView: UIView = {
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
    
    private lazy var viewWithDetailInfo = DetailHeroBottomSubview(
        navigationController: self.navigationController,
        vm: viewModel
    )
    
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
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.height * detailModalOverlapValue)
        }
        
        box.addSubview(heroImageView)
        heroImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        box.addSubview(heroNameText)
        heroNameText.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        view.addSubview(upperAlphaView)
        upperAlphaView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
        }
        
        view.addSubview(viewWithDetailInfo)
        viewWithDetailInfo.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        viewWithDetailInfoTopConstraint = viewWithDetailInfo.topAnchor.constraint(equalTo: box.bottomAnchor, constant: lowestDetailInfoYPositionConstant)
        viewWithDetailInfoTopConstraint.isActive = true
        viewWithDetailInfo.currentViewTopConstraint = viewWithDetailInfoTopConstraint
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        viewWithDetailInfo.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Update View
    private func updateView() {
        if let imgLink = viewModel.heroItem.thumbnail {
            Task {
                heroImageView.image = try await viewModel.getHeroImage(from: imgLink.fullPath)
            }
        }
        
        heroNameText.text = viewModel.heroItem.name
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Pan Gesture funcs
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newTopConstant = max(
            viewWithDetailInfoTopConstraint.constant + translation.y,
            highestSafeeAreaYPosition
        )
        let velocity = gesture.velocity(in: view)
        let lowestYPosition = viewWithDetailInfoTopConstraint.constant
        var absNewTopConstant: Double {
            abs(newTopConstant) / 1000
        }
        var scaledValueForBgImage: Double {
            1 - absNewTopConstant / 10
        }
        
        switch gesture.state {
        case .changed:
            viewWithDetailInfo.hideTopSwipeIcon(newTopConstant == highestSafeeAreaYPosition)
            
            viewWithDetailInfoTopConstraint.constant = newTopConstant < lowestDetailInfoYPositionConstant
            ? (newTopConstant > highestSafeeAreaYPosition ? newTopConstant : highestSafeeAreaYPosition)
            : lowestYPosition
            
            // для плавного затемнения фонового изображения героя
            upperAlphaView.backgroundColor = UIColor.bgColor.withAlphaComponent(absNewTopConstant)
            heroImageView.transform = CGAffineTransform(scaleX: scaledValueForBgImage, y: scaledValueForBgImage)
            
            gesture.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            if abs(velocity.y) > 1000 {
                if velocity.y < 0 {
                    animateViewToTop()
                } else {
                    animateViewToOriginalPosition()
                }
            } else {
                if abs(newTopConstant) > view.frame.height * (detailModalOverlapValue / 2) {
                    animateViewToTop()
                } else {
                    animateViewToOriginalPosition()
                }
            }
        default:
            break
        }
    }
    
    func animateViewToOriginalPosition() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewWithDetailInfo.hideTopSwipeIcon(false)
            self.viewWithDetailInfoTopConstraint.constant = self.lowestDetailInfoYPositionConstant
            self.upperAlphaView.backgroundColor = nil
            self.heroImageView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateViewToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewWithDetailInfo.hideTopSwipeIcon()
            self.viewWithDetailInfoTopConstraint.constant = self.highestSafeeAreaYPosition
            self.upperAlphaView.backgroundColor = UIColor.bgColor
            self.viewWithDetailInfo.hideTopSwipeIcon()
            self.view.layoutIfNeeded()
        })
    }
}
