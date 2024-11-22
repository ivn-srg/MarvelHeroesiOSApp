//
//  UserDefaults.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 22.11.2024.
//

import Foundation

final class UDManager {
    static let shared = UDManager()
    
    private let userDefaults = UserDefaults.standard
    private let currentPageKey = "currentPageNumber"
    private let previousOffsetKey = "currentOffsetValue"
    
    func getCurrentPosition() -> (Int, CGFloat) {
        let savedPage = userDefaults.integer(forKey: currentPageKey)
        let savedOffset = userDefaults.value(forKey: previousOffsetKey) as? CGFloat
        
        if let savedOffset = savedOffset {
            return (savedPage, savedOffset)
        } else {
            return (savedPage, 0)
        }
    }
    
    func saveCurrentPage(_ page: Int) {
        userDefaults.set(page, forKey: currentPageKey)
    }
    
    func savePreviousOffset(_ offset: CGFloat) {
        userDefaults.set(offset, forKey: previousOffsetKey)
    }
    
    func deleteCurrentPosition() {
        userDefaults.removeObject(forKey: currentPageKey)
        userDefaults.removeObject(forKey: previousOffsetKey)
    }
    
    func cleanAll() {
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
