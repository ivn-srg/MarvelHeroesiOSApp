//
//  TriangView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.03.2024.
//

import UIKit

final class TriangleView: UIView {
    
    var colorOfTriangle: UIColor {
        didSet {
            shapeLayer.fillColor = colorOfTriangle.cgColor
        }
    }
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    init(colorOfTriangle: UIColor, frame: CGRect) {
        self.colorOfTriangle = colorOfTriangle
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
        trianglePath.move(to: CGPoint(x: frame.size.width, y: frame.height * 0.64))
        trianglePath.addLine(to: CGPoint(x: 0, y: frame.size.height * 0.64))
        trianglePath.addLine(to: CGPoint(x: frame.size.width, y: 0))
        trianglePath.close()
        return trianglePath
    }
}
