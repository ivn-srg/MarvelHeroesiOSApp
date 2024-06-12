//
//  XCTestExtensions.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 12.06.2024.
//

import Foundation
import XCTest

extension XCUIScreenshot {
    /// Получает цвет пикселя на скриншоте в заданной координате.
    func pixelColor(at coordinate: XCUICoordinate) -> UIColor {
        guard let cgImage = self.image.cgImage else {
            fatalError("Не удалось получить CGImage из XCUIScreenshot")
        }
        
        // Получаем данные пикселей изображения
        guard let pixelData = cgImage.dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData) else {
            fatalError("Не удалось получить данные пикселей из CGImage")
        }
        
        let bytesPerPixel = 4
        let scale = UIScreen.main.scale
        let x = Int(coordinate.screenPoint.x * scale)
        let y = Int(coordinate.screenPoint.y * scale)
        
        // Проверяем границы
        guard x >= 0, y >= 0, x < cgImage.width, y < cgImage.height else {
            fatalError("Координаты выходят за границы изображения")
        }
        
        let pixelIndex = (y * cgImage.width + x) * bytesPerPixel
        
        // Извлекаем значения цветов
        let red = CGFloat(data[pixelIndex]) / 255.0
        let green = CGFloat(data[pixelIndex + 1]) / 255.0
        let blue = CGFloat(data[pixelIndex + 2]) / 255.0
        let alpha = CGFloat(data[pixelIndex + 3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
