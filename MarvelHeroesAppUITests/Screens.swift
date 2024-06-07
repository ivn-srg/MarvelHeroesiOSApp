//
//  Screens.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 01.06.2024.
//

import Foundation
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct HeroListScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let collectionView = "heroCollection"
        static let triangleView = "triangleView"
        static let cellName = "heroCellName"
    }
    
    private lazy var collectionCells = {
        app.collectionViews[Identifiers.collectionView].cells
    }()
    
    private lazy var firstCell = {
        collectionCells.element(boundBy: 0)
    }()
    
    lazy var firstCellTitle = {
        firstCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
    }()
    
    private lazy var secondCell = {
        collectionCells.element(boundBy: 1)
    }()
    
    private lazy var secondCellTitle = {
        secondCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
    }()
    
    init(app: XCUIApplication) {
        self.app = app
    }

    mutating func checkTwoHeroCards() {
        XCTAssertEqual(collectionCells.count, 2, "В collectionView 2 элемента")
        XCTAssertTrue(firstCell.exists, "Deadpool's cell not exists")
        XCTAssertEqual(firstCellTitle, "Deadpool", "Deadpool's cell title isn't correct")
        XCTAssertTrue(secondCell.exists, "Iron Man's cell not exists")
        XCTAssertEqual(secondCellTitle, "Iron Man", file: "Iron Man's cell title isn't correct")
    }
    
    mutating func checkLayoutColorAfterSwaping() {
        let collectionView = app.collectionViews[Identifiers.collectionView]
        let triangleView = app.otherElements[Identifiers.triangleView]
        let backgroundLayoutColor = triangleView.accessibilityLabel
        
        XCTAssertGreaterThanOrEqual(collectionCells.count, 2, "В collectionView нет карточек/одна карточка")
        
        collectionView.swipeLeft()
        
        let backgroundLayoutColorAfterSwaping = triangleView.accessibilityLabel
        
        XCTAssertNotEqual(backgroundLayoutColor, backgroundLayoutColorAfterSwaping, "Цвета layout после свайпинга равны")
        
        collectionView.swipeRight()
        
        let backgroundLayoutColorAfterBackSwaping = app.otherElements[Identifiers.triangleView].accessibilityValue
        XCTAssertEqual(backgroundLayoutColor, backgroundLayoutColorAfterBackSwaping, "Цвета layout после свайпинга не равны")
    }
    
    mutating func checkHeroNameAfterRefreshing() {
        let firstCellTitleBeforeRefresh = firstCellTitle
        let secondCellTitleBeforeRefresh = secondCellTitle
        let element = app.windows.element
        
        element.swipeDown()
        
        let firstCellTitleAfterRefresh = firstCellTitle
        let secondCellTitleAfterRefresh = secondCellTitle
        
        XCTAssertEqual(firstCellTitleBeforeRefresh, firstCellTitleAfterRefresh, "Имена героя до и после обновления не совпадают")
        XCTAssertEqual(secondCellTitleBeforeRefresh, secondCellTitleAfterRefresh, "Имена героя до и после обновления не совпадают")
    }
    
    mutating func fallingIntoDetailScreen() -> DetailHeroScreen {
        firstCell.tap()
        
        return DetailHeroScreen(app: app)
    }
}

struct DetailHeroScreen: Screen {
    let app: XCUIApplication
    
    private enum Identifiers {
        static let backButton = "backButton"
        static let heroDetailName = "heroNameLabel"
        static let heroDetailInfo = "heroInfoLabel"
        static let heroCellName = "heroCellName"
    }
    
    func verifyNameIntoCellAndDetailScreen(with cellTitle: String) {
        let detailViewLblName = app.staticTexts.containing(.staticText, identifier: Identifiers.heroDetailName).element.label
        let detailViewLblInfo = app.staticTexts.containing(.staticText, identifier: Identifiers.heroDetailInfo).element
        
        XCTAssertEqual(cellTitle, detailViewLblName, "Имена героя в ячейке и на экране детализации не совпадают")
        XCTAssertTrue(detailViewLblInfo.exists, "Элемент с информацией по герою не существует")
    }
}
