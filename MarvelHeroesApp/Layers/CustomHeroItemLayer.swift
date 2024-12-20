//
//  CustomHeroItemLayer.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.03.2024.
//

import UIKit

final class CustomHeroItemLayer: UICollectionViewFlowLayout {
    
    var currentPage = 0 {
        didSet {
            UDManager.shared.saveCurrentPage(currentPage)
        }
    }
    
    var previousOffset: CGFloat = 0 {
        didSet {
            UDManager.shared.savePreviousOffset(previousOffset)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        (currentPage, previousOffset) = UDManager.shared.getCurrentPosition()
        
        let itemCount = cv.numberOfItems(inSection: 0)
        
        if previousOffset > cv.contentOffset.x && velocity.x < 0.0 {
            currentPage = max(currentPage - 1, 0)
        } else if previousOffset < cv.contentOffset.x && velocity.x > 0.0 {
            currentPage = min(currentPage + 1, itemCount - 1)
        }
        
        let offset = updateOffset(cv)
        previousOffset = offset
        
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
    
    func updateOffset(_ cv: UICollectionView) -> CGFloat {
        let w = cv.frame.width
        let itemW = itemSize.width
        let sp = minimumLineSpacing
        let edge = (w - itemW - sp * 2) / 2
        let offset = (itemW + sp) * CGFloat(currentPage) - (edge + sp)
        
        return offset
    }
}
