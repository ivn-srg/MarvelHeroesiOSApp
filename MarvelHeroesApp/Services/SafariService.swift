//
//  SafariService.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 22.11.2024.
//

import UIKit
import SafariServices

final class SafariVC: SFSafariViewController {
    static func openLinkInSafari(with navigationController: UINavigationController?, _ urlString: String) {
        guard let navigationController = navigationController, let url = URL(string: urlString) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
}
