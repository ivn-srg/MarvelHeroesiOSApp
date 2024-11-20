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
    func getImage(to targetImageView: UIImageView) async throws
}

final class GeneralCollectionViewCell: UICollectionViewCell, DetailHeroItemCellProtocol {
    // MARK: - Variables
    static var identifier = "CollectionViewCellId"
    
    var viewModel: CellViewModelProtocol?
    weak var viewController: DetailHeroViewController?
    
    // MARK: - UI components
    
    private lazy var cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = MockUpImage
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private lazy var cellTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: Font.InterBold, size: 20)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .lightGray
        return ai
    }()

    // MARK: - Lyfecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTitleLbl.text = nil
        cellImageView.image = nil
    }
    
    // MARK: - Functions
    
    func configure(comics: ComicsItemRO?) {
        setupUI()
        guard let comics = comics else {
            cellImageView.image = MockUpImage
            cellTitleLbl.text = ""
            return
        }
        
        viewModel = ComicsCellViewModel(resourseURI: comics.resourceURI)
        
        Task {
            activityIndicator.startAnimating()
            do {
                if let viewModel = viewModel {
                    try await viewModel.getImage(to: cellImageView)
                } else {
                    print("No view model for comics \(comics)")
                }
            } catch {
                print(error)
            }
            activityIndicator.stopAnimating()
        }
        
        cellTitleLbl.text = comics.name
    }
    
    func setupUI() {
        contentView.addSubview(activityIndicator)
        activityIndicator.center = center
        
        contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().multipliedBy(0.67)
        }
        
        contentView.addSubview(cellTitleLbl)
        cellTitleLbl.snp.makeConstraints {
            $0.top.equalTo(cellImageView.snp.bottom).offset(5)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
