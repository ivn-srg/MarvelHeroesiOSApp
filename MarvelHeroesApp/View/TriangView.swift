//
//  TriangView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.03.2024.
//

import UIKit

class TriangleView: UIView {
    
    var colorOfTriangle: Int {
        didSet {
            drawTriangle(with: RectForTriagle, color: colorOfTriangle)
        }
    }
    
    init(colorOfTriangle: Int, frame: CGRect) {
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
    
    func drawTriangle(with rect: CGRect, color: Int) {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.size.width, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: rect.size.width, y: 0))
        trianglePath.close()
        
        let fillColor = UIColor(rgb: color)
        fillColor.setFill()
        trianglePath.fill()
        trianglePath.stroke()
    }
}

