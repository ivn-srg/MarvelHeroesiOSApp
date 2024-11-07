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
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: ShortInfoItemModel<ComicsItem>?
    let series: ShortInfoItemModel<ComicsItem>?
    let stories: ShortInfoItemModel<StoriesItem>?
    let events: ShortInfoItemModel<ComicsItem>?
    let urls: [URLElement]
}

extension HeroItemModel {
    static var emptyObject: Self {
        HeroItemModel(
            id: 0,
            name: "",
            description: "",
            modified: "",
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
        
        if let comics = cashedHero.comics {
            self.comics = ShortInfoItemModel(
                available: comics.available,
                collectionURI: comics.collectionURI,
                items: comics.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: comics.returned
            )
        } else {
            self.comics = ShortInfoItemModel.empty
        }
        
        if let series = cashedHero.series {
            self.series = ShortInfoItemModel(
                available: series.available,
                collectionURI: series.collectionURI,
                items: series.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: series.returned
            )
        } else {
            self.series = ShortInfoItemModel.empty
        }
        
        if let stories = cashedHero.stories {
            self.stories = ShortInfoItemModel(
                available: stories.available,
                collectionURI: stories.collectionURI,
                items: stories.items.map { StoriesItem(resourceURI: $0.resourceURI, name: $0.name, type: $0.type) },
                returned: stories.returned
            )
        } else {
            self.stories = ShortInfoItemModel.empty
        }
        
        if let events = cashedHero.events {
            self.events = ShortInfoItemModel(
                available: events.available,
                collectionURI: events.collectionURI,
                items: events.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: events.returned
            )
        } else {
            self.events = ShortInfoItemModel.empty
        }
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

