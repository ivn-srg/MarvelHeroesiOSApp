//
//  Extensions.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import UIKit

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

    /// Возвращает средний цвет изображения
    /// 
    /// - Возвращает: UIColor, представляющий средний цвет изображения.
    func averageColor() -> UIColor? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesPerRow * height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var red = 0.0
        var green = 0.0
        var blue = 0.0
        var alpha = 0.0
        
        for i in 0..<height {
            for j in 0..<width {
                let pixelIndex = (i * bytesPerRow) + (j * bytesPerPixel)
                
                let r = Double(bitmapData[pixelIndex])
                let g = Double(bitmapData[pixelIndex + 1])
                let b = Double(bitmapData[pixelIndex + 2])
                let a = Double(bitmapData[pixelIndex + 3])
                
                red += r
                green += g
                blue += b
                alpha += a
            }
        }
        
        bitmapData.deallocate()
        
        let totalPixels = Double(width * height)
        let averageRed = red / totalPixels
        let averageGreen = green / totalPixels
        let averageBlue = blue / totalPixels
        let averageAlpha = alpha / totalPixels
        
        return UIColor(red: CGFloat(averageRed), green: CGFloat(averageGreen), blue: CGFloat(averageBlue), alpha: CGFloat(averageAlpha))
    }
}
