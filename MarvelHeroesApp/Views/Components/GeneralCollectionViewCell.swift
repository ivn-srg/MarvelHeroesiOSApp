//
//  ComicsCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import UIKit

protocol DetailHeroItemCellProtocol: AnyObject {
    var viewModel: CellViewModelProtocol? { get }
    var viewController: DetailHeroViewController? { get }
    static var identifier: String { get }
    
    func setupUI()
}

protocol CellViewModelProtocol: AnyObject {
    func getImage() async throws -> UIImage
}

final class GeneralCollectionViewCell: UICollectionViewCell, DetailHeroItemCellProtocol {
    // MARK: - Variables
    static var identifier = "CollectionViewCellId"
    
    var viewModel: CellViewModelProtocol?
    weak var viewController: DetailHeroViewController?
    private var entityImage: UIImage?
    
    // MARK: - UI components
    
    private lazy var cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private lazy var cellTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: Font.InterRegular, size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = loaderColor
        return ai
    }()

    // MARK: - Lyfecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTitleLbl.text = nil
        cellImageView.image = nil
    }
    
    // MARK: - Functions
    @MainActor func configure(entities: ComicsItemRO?) {
        setupUI()
        guard let entities = entities else {
            cellImageView.image = MockUpImage
            cellTitleLbl.text = ""
            return
        }
        
        viewModel = ComicsCellViewModel(resourseURI: entities.resourceURI)
        
        cellImageView.addObserver(self, forKeyPath: "cellImageView", options: [.new], context: nil)
        
        Task {
            activityIndicator.startAnimating()
            do {
                if let viewModel = viewModel {
                    cellImageView.image = try await viewModel.getImage()
                } else {
                    print("No view model for comics \(entities)")
                }
            } catch {
                print(error)
            }
            activityIndicator.stopAnimating()
        }
        
        cellTitleLbl.text = entities.name
    }
    
    func setupUI() {
        contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().multipliedBy(0.8)
        }
        
        contentView.addSubview(cellTitleLbl)
        cellTitleLbl.snp.makeConstraints {
            $0.top.equalTo(cellImageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(activityIndicator)
        activityIndicator.center = center
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "cellImageView" {
            guard let img = cellImageView.image else { return }
            entityImage = img
        }
    }
}
