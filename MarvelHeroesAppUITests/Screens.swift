//
//  Screens.swift
//  MarvelHeroesAppUITests
//
//  Created by Sergey Ivanov on 23.05.2024.
//

import Foundation
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct HeroesListScreen: Screen {
    var app: XCUIApplication
    
    private enum Identifiers {
        static let collection = "heroCollection"
        static let password = "password"
        static let login = "login"
        static let error = "error"
    }
    
    func checkCountOfItems() -> Self {
        let cv = app.collectionViews[Identifiers.collection]
        cv.tap()
        return self
    }
}

struct HeroDetailScreen: Screen {
    var app: XCUIApplication
    
    private enum Identifiers {
        static let collection = "heroCollection"
        static let password = "password"
        static let login = "login"
        static let error = "error"
    }
    
    func checkCountOfItems() -> Self {
        let cv = app.collectionViews[Identifiers.collection]
        cv.tap()
        return self
    }
}
