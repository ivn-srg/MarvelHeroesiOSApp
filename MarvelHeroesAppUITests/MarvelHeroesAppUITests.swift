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
    
    private var mockService: APIMockManager!
    private var viewModel: HeroListViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockService = APIMockManager.shared
        viewModel = HeroListViewModel(networkService: mockService)
        
        if let scenes = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            scenes.keyWindow?.rootViewController = HeroListViewController(vm: viewModel)
        } else {
            print("Ошибка получения сцен")
        }

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let collectionView = app.collectionViews["heroCollection"]
        XCTAssertTrue(collectionView.exists)
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
