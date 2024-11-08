//
//  GenericModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 07.11.2024.
//

struct DataWrapper<T: Codable>: Codable {
    let code: Int
    let status: String
    let etag: String
    let data: DataContainer<T>
}

struct DataContainer<T: Codable>: Codable {
    let offset, limit, total, count: Int
    let results: [T]
}

extension DataContainer {
    init(results: [T]) {
        self.offset = 0
        self.limit = 0
        self.total = 0
        self.count = 0
        self.results = results
    }
}

struct ListOfEntitiesOfItemModel<T: Codable>: Codable{
    static var empty: Self {
        .init(available: 0, collectionURI: "", items: [], returned: 0)
    }
    
    let available: Int
    let collectionURI: String
    let items: [T]
    let returned: Int
}
