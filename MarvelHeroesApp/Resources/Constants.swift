//
//  Constants.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 03.03.2024.
//

import UIKit
import RealmSwift

// screen size
let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
let window = windowScene?.windows.first(where: { $0.isKeyWindow })
let safeArea = UIScreen.main.bounds.inset(by: window?.safeAreaInsets ?? UIEdgeInsets.zero)

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let horizontalPadding: CGFloat = 16

// images
let Logo = UIImage(named: "marvelLogo")
let QuestionImage = UIImage(systemName: "questionmark")
let MockUpImage = UIImage(named: "mockup")!
let emptyEntityImage = UIImage(named: "emptyEntity")!
let minusImage: UIImage? = {
    let img = UIImage(systemName: "minus")?.withRenderingMode(.alwaysTemplate)
        .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    img?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    return img
}()

// localizable strings
let mainScreenTitle = NSLocalizedString("mainScreenTitle", comment: "")

// mockUpData
let mockUpHeroData = HeroItemModel.emptyObject
let heroDescriptionMock = "Just a cool Marvel hero"
let mockUpListData = List<HeroEntityItemRO>()

// network constants
let imageNotAvailable = "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
let apiManager = APIManager.shared
