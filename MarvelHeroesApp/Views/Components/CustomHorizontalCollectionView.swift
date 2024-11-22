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
    
    var dataWrapperType: Codable.Type {
        switch self {
        case .comics:
            return ComicsItemModel.self
        case .stories:
            return StoriesModel.self
        case .creators:
            return CreatorsModel.self
        case .events:
            return EventsModel.self
        case .series:
            return SeriesModel.self
        }
    }
}

protocol GeneralDataContainerProtocol: AnyObject {
    var available: Int { get }
    var collectionURI: String { get }
    var returned: Int { get }
    var itemsListToArray: [GeneralHeroItemProtocol] { get }
}

class CustomHorizontalCollectionView: UIView {
    // MARK: - Fields
    private var data = [GeneralHeroItemProtocol]()
    var collectionType: EntitiesType?
    
    // MARK: - UI components
    private let collectionViewTitleLbl: LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Font.InterBold, size: 25)
        label.textColor = .white
        label.numberOfLines = 1
        label.edgeInsets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
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
    
    func update(with data: GeneralDataContainerProtocol?) {
        if let data = data?.itemsListToArray, !data.isEmpty {
            collectionViewTitleLbl.text = collectionType?.rawValue
            self.data = data
            collectionView.reloadData()
        } else {
            self.isHidden = true
        }
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
        
        cell.configure(collectionType: collectionType, entities: data[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
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
