//
//  Constants.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import UIKit

// screen size
let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
let window = windowScene?.windows.first(where: { $0.isKeyWindow })
let safeArea = UIScreen.main.bounds.inset(by: window?.safeAreaInsets ?? UIEdgeInsets.zero)

let RectForTriagle = CGRect(
    x: 0,
    y: safeArea.height * 0.3,
    width: safeArea.width,
    height: safeArea.height * 0.59
)

// color
let bgColor = UIColor(rgb: 0x2b272b)
let loaderColor = UIColor(rgb: 0xF31B2A)

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

// images
let Logo = UIImage(named: "marvelLogo")
let QuestionImage = UIImage(systemName: "questionmark")
let MockUpImage = UIImage(named: "mockup")

// localizable strings
let mainScreenTitle = NSLocalizedString("mainScreenTitle", comment: "")

// mockUpData
let mockUpHeroData = HeroModel(id: 1, name: "Unknown hero", description: "", thumbnail: ThumbnailModel(path: "", extension: ""))
