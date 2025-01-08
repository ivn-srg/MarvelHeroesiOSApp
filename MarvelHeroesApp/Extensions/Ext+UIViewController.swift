//
//  Ext+UIViewController.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

import UIKit

extension UIViewController {
    // Universalized func for error handling
    func executeWithErrorHandling(_ action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                await MainActor.run {
                    UIAlertController.showSimpleAlert(on: self, message: error.localizedDescription)
                }
            }
        }
    }
}
