//
//  MarvelHeroesAppUITests.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 29.05.2024.
//

import XCTest
@testable import MarvelHeroesApp

final class HeroListTests: XCTestCase {
    
    private var app: XCUIApplication! = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launchArguments.append("UITests")
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
}

final class MarvelHeroesAppUITests: XCTestCase {
    
    private var app: XCUIApplication! = XCUIApplication()
    
    private var collectionCells: XCUIElementQuery! {
        app.collectionViews["heroCollection"].cells
    }
    private var firstCell: XCUIElement! {
        collectionCells.element(boundBy: 0)
    }
    private var firstCellTitle: String! {
        firstCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
    }
    private var secondCell: XCUIElement! {
        collectionCells.element(boundBy: 1)
    }
    private var secondCellTitle: String! {
        secondCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
    }

    override func setUpWithError() throws {
        app.launchArguments.append("UITests")
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // first test case
    func testHeroListScreenFlow() {
        HeroListScreen(app: app)
            .checkTwoHeroCards()
            .checkHeroNameAfterRegreshing()
//            .checkLayoutColorAfterSwaping()
            .fallingIntoDetailScreen()
            .verifyNameIntoCellAndDetailScreen(with: firstCellTitle)
    }
    
    // second test case
    func testFallingIntoDetailScreen() throws {
        let firstCellTitle = firstCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
        firstCell.tap()
        let detailViewLblName = app.staticTexts.containing(.staticText, identifier: "heroName").element.label
        let detailViewLblInfo = app.staticTexts.containing(.staticText, identifier: "heroInfo").element
        
        XCTAssertEqual(firstCellTitle, detailViewLblName, "Имена героя в ячейке и на экране детализации не совпадают")
        XCTAssertTrue(detailViewLblInfo.exists, "Элемент с информацией по герою не существует")
    }
    
    // third test case
    func testCheckLayoutColorAfterSwaping() {
        
    }
    
    // fourth test case
    func testCheckHeroNameAfterRefreshing() {
        
    }
}
