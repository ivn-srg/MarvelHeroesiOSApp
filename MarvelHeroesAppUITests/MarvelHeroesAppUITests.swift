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
    private var heroListScreen: HeroListScreen!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments.append("UITests")
        app.launch()
        
        heroListScreen = HeroListScreen(app: app)
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func test1CheckTwoHeroCards() {
        heroListScreen.checkTwoHeroCards()
    }
    
    func test2CheckHeroNameAfterRefreshing() {
        heroListScreen.checkHeroNameAfterRefreshing()
    }
    
    func test3CheckLayoutColorAfterSwaping() {
        heroListScreen.checkLayoutColorAfterSwaping()
    }
    
    func test4VerifyNameIntoCellAndDetailScreen() {
        let cellTitle = heroListScreen.firstCellTitle
        heroListScreen.fallingIntoDetailScreen().verifyNameIntoCellAndDetailScreen(with: cellTitle)
    }
}
