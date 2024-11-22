//
//  StackWithButtonsView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 22.11.2024.
//

import UIKit

final class StackWithButtonsView: UIView {
    // MARK: - Fields
    private var listOfURLs: [URLElementRO]
    private var navControl: UINavigationController?
    
    // MARK: - UI components
    private let titleLbl: LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Font.InterBold, size: 25)
        label.textColor = .white
        label.numberOfLines = 1
        label.text = "Интересные материалы".localized
        label.edgeInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private var itemButton: UIButton {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = UIColor.darkRedColor
        config.buttonSize = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        config.cornerStyle = .medium
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: Font.InterRegular, size: 14)
        return button
    }
    
    
    // MARK: - Lyfecycle
    init(navigationController: UINavigationController?, listOfURLs: [URLElementRO]) {
        self.listOfURLs = listOfURLs
        self.navControl = navigationController
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(5)
            $0.horizontalEdges.bottom.equalToSuperview().inset(horizontalPadding)
            $0.bottom.equalToSuperview()
        }
        
        for item in listOfURLs {
            let button = itemButton
            button.setTitle(item.type.capitalized, for: .normal)
            let action = UIAction { _ in
                SafariVC.openLinkInSafari(with: self.navControl, item.url)
            }
            button.addAction(action, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    func setListUrls(_ urls: [URLElementRO]) {
        listOfURLs = Array(urls)
    }
}
