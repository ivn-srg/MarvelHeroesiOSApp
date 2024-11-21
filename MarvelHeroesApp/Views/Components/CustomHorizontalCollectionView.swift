//
//  CustomHorizontalCollectionView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import UIKit
import RealmSwift

enum EntitiesType: String {
    case comics = "Comics"
    case stories = "Stories"
    case creators = "Creators"
    case events = "Events"
    case series = "Series"
    
    var title: String {
        switch self {
        case .comics: return "Comics".localized
        case .stories: return "Stories".localized
        case .creators: return "Creators".localized
        case .events: return "Events".localized
        case .series: return "Series".localized
        }
    }
}

class CustomHorizontalCollectionView: UIView {
    // MARK: - Fields
    private var data = List<ComicsItemRO>()
    var collectionType: EntitiesType?
    
    // MARK: - UI components
    private let collectionViewTitleLbl: LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Font.InterBold, size: 25)
        label.textColor = .white
        label.numberOfLines = 1
        label.edgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return label
    }()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: GeneralCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        addSubview(collectionViewTitleLbl)
        collectionViewTitleLbl.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(collectionViewTitleLbl.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func update(with data: List<ComicsItemRO>) {
        collectionViewTitleLbl.text = collectionType?.rawValue
        self.data = data
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension CustomHorizontalCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GeneralCollectionViewCell.identifier,
                for: indexPath) as? GeneralCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        guard let entity = data[indexPath.row] as? ComicsItemRO else { return cell }
        cell.configure(entities: entity)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CustomHorizontalCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 240, height: self.frame.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        40
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        40
    }
}