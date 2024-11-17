//
//  ComicsCollectionViewCell.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import UIKit

final class ComicsCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    static let identifier = "ComicsCollectionViewCellId"
    
    private var viewModel: ComicsCellViewModel?
    weak var viewController: DetailHeroViewController?
    
    // MARK: - UI components
    
    private lazy var comicsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = MockUpImage
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private lazy var comicsTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: Font.InterBold, size: 28)
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
        
        comicsTitleLbl.text = nil
        comicsImageView.image = nil
    }
    
    // MARK: - Functions
    
    public func configure(comics: ComicsItemRO?) {
        setupUI()
        guard let comics = comics else {
            comicsImageView.image = MockUpImage
            comicsTitleLbl.text = ""
            return
        }
        
        viewModel = ComicsCellViewModel(resourseURI: comics.resourceURI)
        
        Task {
            activityIndicator.startAnimating()
            do {
                if let viewModel = viewModel {
                    try await viewModel.getImage(to: comicsImageView)
                } else {
                    print("No view model for comics \(comics)")
                }
            } catch {
                print(error)
            }
            activityIndicator.stopAnimating()
        }
        
        comicsTitleLbl.text = comics.name
    }
    
    private func setupUI() {
        addSubview(activityIndicator)
        activityIndicator.center = center
        
        addSubview(comicsImageView)
        comicsImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(comicsTitleLbl)
        comicsTitleLbl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
