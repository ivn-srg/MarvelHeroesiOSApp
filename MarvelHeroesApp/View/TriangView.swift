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
            drawTriangle(with: RectForTriagle, color: colorOfTriangle)
        }
    }
    
    init(colorOfTriangle: UIColor, frame: CGRect) {
        self.colorOfTriangle = colorOfTriangle
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawTriangle(with: rect, color: colorOfTriangle)
    }
    
    func drawTriangle(with rect: CGRect, color: UIColor) {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.size.width, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: rect.size.width, y: 0))
        
        let fillColor = color
        fillColor.setFill()
        trianglePath.fill()
        trianglePath.stroke()
    }
}

