//
//  MarvelHeroesAppUITests.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 29.05.2024.
//

import XCTest
@testable import MarvelHeroesApp

final class MarvelHeroesAppUITests: XCTestCase {
    
    private var app: XCUIApplication! = XCUIApplication()

    override func setUpWithError() throws {
        app.launchArguments.append("UITests")
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testMainFlow() {
        let collectionCells = app.collectionViews["heroCollection"].cells
        let firstCell = collectionCells.element(boundBy: 0)
        let firstCellTitle = firstCell.staticTexts.containing(.staticText, identifier: "heroCellName").element.label
        
        HeroListScreen(app: app)
            .checkTwoHeroCards()
            .checkHeroNameAfterRegreshing()
            .checkLayoutColorAfterSwaping()
            .fallingIntoDetailScreen()
            .verifyNameIntoCellAndDetailScreen(with: firstCellTitle)
    }
}
