//
//  Ext+AlertController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

import UIKit

extension UIAlertController {
    static func showSimpleAlert(
        on viewController: UIViewController,
        title: String = String(localized: "errorTitle"),
        message: String
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
