//
//  LabelWithPadding.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 21.11.2024.
//
import Foundation
import UIKit

final class LabelWithPadding: UILabel {
    var edgeInsets: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
}
