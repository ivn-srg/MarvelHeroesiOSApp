//
//  CreatorsModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 08.11.2024.
//

import Foundation

typealias Heroes = [HeroItemModel]

struct HeroItemModel: Codable {
    let id: Int
    let name, description: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: ListOfEntitiesOfItemModel<ComicsItem>?
    let series: ListOfEntitiesOfItemModel<ComicsItem>?
    let stories: ListOfEntitiesOfItemModel<StoriesItem>?
    let events: ListOfEntitiesOfItemModel<ComicsItem>?
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
            self.comics = ListOfEntitiesOfItemModel(
                available: comics.available,
                collectionURI: comics.collectionURI,
                items: comics.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: comics.returned
            )
        } else {
            self.comics = ListOfEntitiesOfItemModel.empty
        }
        
        if let series = cashedHero.series {
            self.series = ListOfEntitiesOfItemModel(
                available: series.available,
                collectionURI: series.collectionURI,
                items: series.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: series.returned
            )
        } else {
            self.series = ListOfEntitiesOfItemModel.empty
        }
        
        if let stories = cashedHero.stories {
            self.stories = ListOfEntitiesOfItemModel(
                available: stories.available,
                collectionURI: stories.collectionURI,
                items: stories.items.map { StoriesItem(resourceURI: $0.resourceURI, name: $0.name, type: $0.type) },
                returned: stories.returned
            )
        } else {
            self.stories = ListOfEntitiesOfItemModel.empty
        }
        
        if let events = cashedHero.events {
            self.events = ListOfEntitiesOfItemModel(
                available: events.available,
                collectionURI: events.collectionURI,
                items: events.items.map { ComicsItem(resourceURI: $0.resourceURI, name: $0.name) },
                returned: events.returned
            )
        } else {
            self.events = ListOfEntitiesOfItemModel.empty
        }
        self.urls = cashedHero.urls.map {URLElement(type: $0.type, url: $0.url) }
    }
}

struct ComicsItemModel: Codable {
    let id, digitalId: Int
    let title: String
    let issueNumber: Int
    let variantDescription: String
    let description: String
    let modified: String
    let isbn: String
    let upc: String
    let diamondCode: String
    let ean: String
    let issn: String
    let format: String
    let pageCount: Int
    let textObjects: [TextObject]
    let resourceURI: String
    let urls: [URLElement]
    let series: Series
    let variants, collections, collectedIssues: [Series]
    let dates: [DateElement]
    let prices: [Price]
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    let creators: ListOfEntitiesOfItemModel<Series>
    let characters: ListOfEntitiesOfItemModel<Series>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let events: ListOfEntitiesOfItemModel<Series>
}

struct CreatorsModel: Codable {
    let id: Int
    let firstName, middleName, lastName, suffix: String
    let fullName: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: ListOfEntitiesOfItemModel<ComicsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let events: ListOfEntitiesOfItemModel<ComicsItem>
    let urls: [URLElement]
}

struct EventsModel: Codable {
    let id: Int
    let title, description: String
    let resourceURI: String
    let urls: [URLElement]
    let modified: String
    let start, end: String?
    let thumbnail: Thumbnail
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let characters: ListOfEntitiesOfItemModel<ComicsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let comics, series: ListOfEntitiesOfItemModel<ComicsItem>
    let next, previous: Series?
}

struct SeriesModel: Codable {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let urls: [URLElement]
    let startYear, endYear: Int
    let rating: String
    let type: String
    let modified: String
    let thumbnail: Thumbnail
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let characters, comics, events: ListOfEntitiesOfItemModel<ComicsItem>
    let next, previous: Series?
}

struct StoriesModel: Codable {
    let id: Int
    let title, description: String
    let resourceURI: String
    let type: String
    let modified: String
    let thumbnail: Thumbnail?
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let events, characters, series, comics: ListOfEntitiesOfItemModel<ComicsItem>
    let originalIssue: Series
}
