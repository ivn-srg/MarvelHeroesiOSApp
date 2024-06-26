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
let mockUpHeroData = HeroModel(id: 0, name: "Unknown hero", heroDescription: "", thumbnail: ThumbnailModel(path: "", extension: ""))

// network constants
let heroImageNotAvailable = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
