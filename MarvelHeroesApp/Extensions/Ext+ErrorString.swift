//
//  Ext+ErrorString.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 18.11.2024.
//

import Foundation

extension String {
    var errorString: StringError {
        StringError(self)
    }
}
