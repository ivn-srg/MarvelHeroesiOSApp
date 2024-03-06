//
//  Constants.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import UIKit

let bgColor = UIColor(rgb: 0x2b272b)

let RectForTriagle = CGRect(
    x: 0,
    y: UIScreen.main.bounds.height * 0.3,
    width: UIScreen.main.bounds.width,
    height: UIScreen.main.bounds.height * 0.6
)

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

// images
let Logo = UIImage(named: "marvelLogo")
let QuestionImage = UIImage(systemName: "questionmark")

// localizable strings
let mainScreenTitle = NSLocalizedString("mainScreenTitle", comment: "")
