//
//  MarvelHeroesAppUITests.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 29.05.2024.
//

import XCTest
@testable import MarvelHeroesApp

final class MarvelHeroesAppUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testExample() throws {
        
        app = XCUIApplication()
        app.launchArguments.append("UITests")
        app.launch()
        
        let collectionCells = app.collectionViews["heroCollection"].cells
        XCTAssertEqual(collectionCells.count, 2, "В collectionView 2 элемента")
        
        let firstCell = collectionCells.element(boundBy: 0)
        let firstCellTitle = firstCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
        let secondCell = collectionCells.element(boundBy: 1)
        let secondCellTitle = secondCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
        
        // first test case
        XCTAssertEqual(firstCellTitle, "Deadpool", "Deadpool's cell not exists")
        XCTAssertEqual(secondCellTitle, "Iron Man", file: "Iron Man's cell not exists")
        
        // second test case
        firstCell.tap()
        let detailViewLblName = app.staticTexts.containing(.staticText, identifier: "heroName").element.label
        let detailViewLblInfo = app.staticTexts.containing(.staticText, identifier: "heroInfo")
        
        XCTAssertEqual(firstCellTitle, detailViewLblName, "Имена героя в ячейке и на экране детализации не совпадают")
        XCTAssertTrue(detailViewLblInfo.element.exists, "Элемент с информацией по герою не существует")
        
        app.buttons["backButton"].tap()
        
        // third test case
        let herocollectionCollectionView = app.collectionViews["heroCollection"]
        let backgroundLayout = app.otherElements["triangleView"].label
        print(backgroundLayout)
        
        herocollectionCollectionView.swipeLeft()
        herocollectionCollectionView.swipeRight()
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
