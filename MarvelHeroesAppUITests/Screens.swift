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

    func checkTwoHeroCards() -> Self {
        let collectionCells = app.collectionViews[Identifiers.collectionView].cells
        let firstCell = collectionCells.element(boundBy: 0)
        let firstCellTitle = firstCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        let secondCell = collectionCells.element(boundBy: 1)
        let secondCellTitle = secondCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        
        XCTAssertEqual(collectionCells.count, 2, "В collectionView 2 элемента")
        XCTAssertEqual(firstCellTitle, "Deadpool", "Deadpool's cell not exists")
        XCTAssertEqual(secondCellTitle, "Iron Man", file: "Iron Man's cell not exists")
        return self
    }
    
    func checkLayoutColorAfterSwaping() -> Self {
        let element = app.windows.element
        element.swipeDown()
        element.swipeDown()
        
        let herocollectionCollectionView = app.collectionViews[Identifiers.collectionView]
        let backgroundLayout = app.otherElements[Identifiers.triangleView]
        
        herocollectionCollectionView.swipeLeft()
        
        let backgroundLayoutAfterSwaping = app.otherElements[Identifiers.triangleView]
        
        XCTAssertNotEqual(backgroundLayout.label, backgroundLayoutAfterSwaping.label, "Цвета layout после свайпинга равны")
        
        herocollectionCollectionView.swipeRight()
        
        let backgroundLayoutAfterBackSwaping = app.otherElements[Identifiers.triangleView]
        XCTAssertEqual(backgroundLayout.label, backgroundLayoutAfterBackSwaping.label, "Цвета layout после свайпинга не равны")
        return self
    }
    
    func checkHeroNameAfterRegreshing() -> Self {
        let collectionCells = app.collectionViews[Identifiers.collectionView].cells
        let firstCell = collectionCells.element(boundBy: 0)
        let firstCellTitle = firstCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        let secondCell = collectionCells.element(boundBy: 1)
        let secondCellTitle = secondCell.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        let element = app.windows.element
        
        element.swipeDown()
        
        let firstCellAfterRefresh = collectionCells.element(boundBy: 0)
        let firstCellTitleAfterRefresh = firstCellAfterRefresh.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        let secondCellAfterRefresh = collectionCells.element(boundBy: 1)
        let secondCellTitleAfterRefresh = secondCellAfterRefresh.staticTexts.containing(.staticText, identifier: Identifiers.cellName).element.label
        
        XCTAssertEqual(firstCellTitle, firstCellTitleAfterRefresh, "Имена героя до и после обновления не совпадают")
        XCTAssertEqual(secondCellTitle, secondCellTitleAfterRefresh, "Имена героя до и после обновления не совпадают")
        return self
    }
    
    func fallingIntoDetailScreen() -> DetailHeroScreen {
        let collectionCells = app.collectionViews[Identifiers.collectionView].cells
        let firstCell = collectionCells.element(boundBy: 0)
        
        firstCell.tap()
        
        return DetailHeroScreen(app: app)
    }
}

struct DetailHeroScreen: Screen {
    let app: XCUIApplication
    
    private enum Identifiers {
        static let backButton = "backButton"
        static let heroDetailName = "heroName"
        static let heroDetailInfo = "heroInfo"
        static let heroCellName = "heroCellName"
    }
    
    func verifyNameIntoCellAndDetailScreen(with cellTitle: String) {
        let detailViewLblName = app.staticTexts.containing(.staticText, identifier: Identifiers.heroDetailName).element.label
        let detailViewLblInfo = app.staticTexts.containing(.staticText, identifier: Identifiers.heroDetailInfo).element
        
        XCTAssertEqual(cellTitle, detailViewLblName, "Имена героя в ячейке и на экране детализации не совпадают")
        XCTAssertTrue(detailViewLblInfo.exists, "Элемент с информацией по герою не существует")
    }
}
