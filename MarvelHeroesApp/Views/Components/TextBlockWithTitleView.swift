//
//  TextBlockWithTitleView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 17.11.2024.
//

import Foundation
import UIKit

final class TextBlockWithTitleViewTests: UIView {
    // MARK: - Fields
    private let titleValue: String
    private let textValue: String
    
    // MARK: - UI components
    private lazy var titleLbl: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterBold, size: 34)
        txt.textColor = .white
        txt.text = "Overview".localized
        txt.numberOfLines = 1
        return txt
    }()
    
    private lazy var detailTextLbl: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: Font.InterRegular, size: 20)
        txt.textColor = .white
        txt.numberOfLines = 0
        return txt
    }()
    
    // MARK: - Lyfecycle
    init(title: String, text: String) {
        self.titleValue = title
        self.textValue = text
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        titleLbl.text = titleValue
        detailTextLbl.text = textValue
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        addSubview(detailTextLbl)
        detailTextLbl.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
