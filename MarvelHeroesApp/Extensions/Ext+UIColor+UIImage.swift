//
//  Extensions.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import UIKit
import CommonCrypto

extension UIColor {
    static let dirtyWhite = UIColor(rgb: 0xefffff)
    static let bgColor = UIColor(rgb: 0x2b272b)
    static let loaderColor = UIColor(rgb: 0xF31B2A)
    static let darkRedColor = UIColor(rgb: 0x931c29)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIImage {
    /// - Возвращает: UIColor, представляющий средний цвет изображения.
    func averageColor() -> UIColor {
        guard let inputImage = CIImage(image: self) else { return .clear }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y  + (inputImage.extent.size.height * 0.7), z: inputImage.extent.size.width, w: inputImage.extent.size.height * 0.3)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return .clear }
        guard let outputImage = filter.outputImage else { return .clear }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension CGColor {
    func toString() -> String {
        guard let components = self.components else {
            return "empty color"
        }
        switch components.count {
        case 2:
            let red = components[0]
            let green = components[1]
            
            return String(format: "r:%.2f g:%.2f", red, green)
        case 3:
            let red = components[0]
            let green = components[1]
            let blue = components[2]
            
            return String(format: "r:%.2f g:%.2f b:%.2f", red, green, blue)
        case 4:
            let red = components[0]
            let green = components[1]
            let blue = components[2]
            let alpha = components[3]
            
            return String(format: "r:%.2f g:%.2f b:%.2f a:%.2f", red, green, blue, alpha)
        default:
            var tempStr = ""
            components.forEach { component in
                tempStr.append("\(component.description) ")
            }
            return tempStr
        }
    }
}
