//
//  ResponseFailureModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 28.03.2024.
//

import Foundation

struct ResponseFailureModel: Codable {
    let code: Int
    let status: String
}
