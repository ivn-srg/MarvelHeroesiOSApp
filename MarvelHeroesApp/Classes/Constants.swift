//
//  Constants.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import UIKit

let bgColor = UIColor(rgb: 0x2b272b)

let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
let window = windowScene?.windows.first(where: { $0.isKeyWindow })
let safeArea = UIScreen.main.bounds.inset(by: window?.safeAreaInsets ?? UIEdgeInsets.zero)

let RectForTriagle = CGRect(
    x: 0,
    y: safeArea.height * 0.3,
    width: safeArea.width,
    height: safeArea.height * 0.59
)

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

// images
let Logo = UIImage(named: "marvelLogo")
let QuestionImage = UIImage(systemName: "questionmark")
let MockUpImage = UIImage(named: "mockup")

// localizable strings
let mainScreenTitle = NSLocalizedString("mainScreenTitle", comment: "")

let BASE_URL = "https://gateway.marvel.com"

let API_KEY = "b803ed8710a243c3c7b40aab280b4195"
let PRIVATE_KEY = "70b08100100ed986893efd5424b60314c084c96a"

// mockUpData
let mockUpHeroData = HeroModel(id: 1, name: "Unknown hero", description: "", thumbnail: ThumbnailModel(path: "", extension: ""))
