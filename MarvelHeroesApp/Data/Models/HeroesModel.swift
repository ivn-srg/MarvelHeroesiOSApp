//
//  ResponseModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 01.03.2024.
//

import Foundation

typealias Heroes = [HeroItemModel]

struct HeroItemModel: Codable {
    let id: Int
    let name, description: String
    let modified: Date
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: ShortInfoItemModel<ComicsItem>
    let series: ShortInfoItemModel<ComicsItem>
    let stories: ShortInfoItemModel<StoriesItem>
    let events: ShortInfoItemModel<ComicsItem>
    let urls: [URLElement]
}

extension HeroItemModel {
    static var emptyObject: Self {
        HeroItemModel(
            id: 0,
            name: "",
            description: "",
            modified: Date(),
            thumbnail: Thumbnail(),
            resourceURI: "",
            comics: .empty,
            series: .empty,
            stories: .empty,
            events: .empty,
            urls: []
        )
    }
    
    init(cashedHero: HeroRO) {
        self.id = cashedHero.id
        self.name = cashedHero.name
        self.description = cashedHero.heroDescription
        self.modified = cashedHero.modified
        self.resourceURI = cashedHero.resourceURI
        
        if let cashedThumb = cashedHero.thumbnail {
            self.thumbnail = Thumbnail(path: cashedThumb.path, thumbnailExtension: cashedThumb.thumbnailExtension)
        } else {
            self.thumbnail = Thumbnail()
        }
        
        self.comics = ShortInfoItemModel(
            available: cashedHero.comics.available,
            collectionURI: cashedHero.comics.collectionURI,
            items: cashedHero.comics.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
            returned: cashedHero.comics.returned
        )
        
        self.series = ShortInfoItemModel(
            available: cashedHero.series.available,
            collectionURI: cashedHero.series.collectionURI,
            items: cashedHero.series.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
            returned: cashedHero.series.returned
        )
        
        self.stories = ShortInfoItemModel(
            available: cashedHero.stories.available,
            collectionURI: cashedHero.stories.collectionURI,
            items: cashedHero.stories.items.map { StoriesItem(resourceURI: $0.resourceURI, name: $0.name, type: ItemType.stringToCase($0.type)) },
            returned: cashedHero.stories.returned
        )
        
        self.events = ShortInfoItemModel(
            available: cashedHero.events.available,
            collectionURI: cashedHero.events.collectionURI,
            items: cashedHero.events.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
            returned: cashedHero.events.returned
        )
        self.urls = cashedHero.urls.map {URLElement(type: $0.type, url: $0.url) }
    }
}

enum TypeEnum: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

extension Thumbnail {
    init() {
        self.path = ""
        self.thumbnailExtension = ""
    }
    
    init(thumbRO: ThumbnailRO) {
        self.path = thumbRO.path
        self.thumbnailExtension = thumbRO.thumbnailExtension
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}

