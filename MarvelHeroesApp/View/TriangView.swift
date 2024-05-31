//
//  TriangView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.03.2024.
//

import UIKit

protocol UpdateTriangleSublayout: AnyObject {
    func updateTriangleSublayout()
}

final class TriangleView: UIView, UpdateTriangleSublayout {
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        layer.addSublayer(shapeLayer)
        shapeLayer.frame = bounds
        shapeLayer.path = createTrianglePath().cgPath
    }
    
    private func createTrianglePath() -> UIBezierPath {
        let trianglePath = UIBezierPath()
        let heightMultiplier = 0.64
        trianglePath.move(to: CGPoint(x: bounds.width, y: bounds.height * heightMultiplier))
        trianglePath.addLine(to: CGPoint(x: 0, y: bounds.height * heightMultiplier))
        trianglePath.addLine(to: CGPoint(x: bounds.size.width, y: 0))
        trianglePath.close()
        return trianglePath
    }
    
    func updateTriangleColor(_ color: UIColor) {
        shapeLayer.fillColor = color.cgColor
    }
    
    func updateTriangleSublayout() {
        self.setNeedsLayout()
    }
}
