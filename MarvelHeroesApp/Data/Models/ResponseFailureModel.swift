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
    
    init(code: String, status: String) {
        self.code = Int(code) ?? 0
        self.status = status
    }
    
    init(code: Int, status: String) {
        self.code = code
        self.status = status
    }
}


let notFoundEntityResponseData = """
<div id="main">
        <div class="fof">
                <h1>Not Found</h1>
        </div>
</div>
""".data(using: .utf8)
