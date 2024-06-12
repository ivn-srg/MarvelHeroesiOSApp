//
//  UIImageExtension.swift
//  MarvelHeroesAppTests
//
//  Created by Sergey Ivanov on 23.05.2024.
//

import Foundation
import UIKit

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
