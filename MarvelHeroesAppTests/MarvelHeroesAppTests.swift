//
//  MarvelHeroesAppTests.swift
//  MarvelHeroesAppTests
//
//  Created by Sergey Ivanov on 23.05.2024.
//

import XCTest
@testable import MarvelHeroesApp

final class MarvelHeroesAppTests: XCTestCase {
    
    var testedImage: UIImage?
    var avgColor: UIColor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        testedImage = UIImage()
    }

    override func tearDownWithError() throws {
        testedImage = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        // функция возвращает пустой цвет при передачи пустого UIImage
        testedImage = UIImage()
        avgColor = testedImage?.averageColor()
        XCTAssertEqual(avgColor, UIColor.clear, "Пустое UIImage обрабатывается ок")
        
        // функция возвращает определенные значения цветов RGB для определенной картинки
        testedImage = UIImage(named: "deadPool")
        avgColor = testedImage?.averageColor()
        let components = avgColor.cgColor.components
        XCTAssertEqual(components![0], 0.216, accuracy: 0.01, "Красный оттенок просчитан ок")
        XCTAssertEqual(components![1], 0.173, accuracy: 0.01, "Зеленый оттенок просчитан ок")
        XCTAssertEqual(components![2], 0.173, accuracy: 0.01, "Синий оттенок просчитан ок")
        XCTAssertEqual(components![3], 1, "Альфа уровень просчитан ок")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            testedImage?.averageColor()
        }
    }

}