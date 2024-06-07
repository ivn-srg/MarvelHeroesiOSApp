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
    private var heroListScreen: HeroListScreen!

    override func setUpWithError() throws {
        ApiServiceConfiguration.shared.setMockingServiceEnabled(true)
        app.launch()
        
        heroListScreen = HeroListScreen(app: app)
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testCheckTwoHeroCards() {
        heroListScreen.checkTwoHeroCards()
    }
    
    func testCheckHeroNameAfterRefreshing() {
        heroListScreen.checkHeroNameAfterRefreshing()
    }
    
    func testCheckLayoutColorAfterSwaping() {
        heroListScreen.checkLayoutColorAfterSwaping()
    }
    
    func testVerifyNameIntoCellAndDetailScreen() {
        let cellTitle = heroListScreen.firstCellTitle
        heroListScreen.fallingIntoDetailScreen().verifyNameIntoCellAndDetailScreen(with: cellTitle)
    }
}
