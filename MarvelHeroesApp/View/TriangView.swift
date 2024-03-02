//
//  TriangView.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 02.03.2024.
//

import UIKit

class TriangleView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.size.width, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: rect.size.height))
        trianglePath.addLine(to: CGPoint(x: rect.size.width, y: 0))
        trianglePath.close()
        
        let fillColor = UIColor.red
        fillColor.setFill()
        trianglePath.fill()
        trianglePath.stroke()
    }
    
    func updateFillColor(color: Int) {
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(self.bounds)
            let trianglePath = UIBezierPath()
            
            trianglePath.move(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
            trianglePath.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
            trianglePath.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
            
            let newColor = UIColor(rgb: color)
            trianglePath.close()
            newColor.setFill()
            trianglePath.fill()
        }
    }
    
    static var triangle = TriangleView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.3, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6))
}

