//
//  CreatorsModel.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 08.11.2024.
//

import Foundation

protocol Item {
    var id: Int { get }
    var thumbnail: Thumbnail? { get }
    var resourceURI: String { get }
    var modified: String { get }
}

typealias Heroes = [HeroItemModel]

struct HeroItemModel: Codable, Item {
    let id: Int
    let name: String
    let description: String?
    let modified: String
    let thumbnail: Thumbnail?
    let resourceURI: String
    let comics: ListOfEntitiesOfItemModel<ComicsItem>?
    let series: ListOfEntitiesOfItemModel<ComicsItem>?
    let stories: ListOfEntitiesOfItemModel<StoriesItem>?
    let events: ListOfEntitiesOfItemModel<ComicsItem>?
    let urls: [URLElement]
    
    init(
        id: Int, name: String, description: String?, modified: String, thumbnail: Thumbnail?,
        resourceURI: String, comics: ListOfEntitiesOfItemModel<ComicsItem>?,
        series: ListOfEntitiesOfItemModel<ComicsItem>?, stories: ListOfEntitiesOfItemModel<StoriesItem>?,
        events: ListOfEntitiesOfItemModel<ComicsItem>?, urls: [URLElement]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.modified = modified
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "hero", thumbnailExtension: "")
        }
        self.resourceURI = resourceURI
        self.comics = comics
        self.series = series
        self.stories = stories
        self.events = events
        self.urls = urls
    }
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

struct ComicsItemModel: Codable, Item {
    let id: Int
    let digitalId: Int?
    let title: String
    let issueNumber: Int?
    let variantDescription: String?
    let description: String?
    let modified: String
    let isbn: String?
    let upc: String?
    let diamondCode: String?
    let ean: String?
    let issn: String?
    let format: String?
    let pageCount: Int
    let textObjects: [TextObject]
    let resourceURI: String
    let urls: [URLElement]
    let series: Series
    let variants, collections, collectedIssues: [Series]
    let dates: [DateElement]
    let prices: [Price]
    let thumbnail: Thumbnail?
    let images: [Thumbnail]
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let characters: ListOfEntitiesOfItemModel<Series>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let events: ListOfEntitiesOfItemModel<Series>
    
    init(
        id: Int, digitalId: Int?, title: String, issueNumber: Int?, variantDescription: String?, description: String?,
        modified: String, isbn: String?, upc: String?, diamondCode: String?, ean: String?, issn: String?, format: String?,
        pageCount: Int, textObjects: [TextObject], resourceURI: String, urls: [URLElement], series: Series, variants: [Series],
        collections: [Series], collectedIssues: [Series], dates: [DateElement], prices: [Price], thumbnail: Thumbnail?,
        images: [Thumbnail], creators: ListOfEntitiesOfItemModel<CreatorsItem>, characters: ListOfEntitiesOfItemModel<Series>,
        stories: ListOfEntitiesOfItemModel<StoriesItem>, events: ListOfEntitiesOfItemModel<Series>
    ) {
        self.id = id
        self.digitalId = digitalId
        self.title = title
        self.issueNumber = issueNumber
        self.variantDescription = variantDescription
        self.description = description
        self.modified = modified
        self.isbn = isbn
        self.upc = upc
        self.diamondCode = diamondCode
        self.ean = ean
        self.issn = issn
        self.format = format
        self.pageCount = pageCount
        self.textObjects = textObjects
        self.resourceURI = resourceURI
        self.urls = urls
        self.series = series
        self.variants = variants
        self.collections = collections
        self.collectedIssues = collectedIssues
        self.dates = dates
        self.prices = prices
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "entity", thumbnailExtension: "")
        }
        self.images = images
        self.creators = creators
        self.characters = characters
        self.stories = stories
        self.events = events
    }
}

extension ComicsItemModel {
    init() {
        self.id = 0
        self.digitalId = 0
        self.title = "Title cell"
        self.issueNumber = 0
        self.variantDescription = "variantDescription"
        self.description = "description"
        self.modified = "modified"
        self.isbn = "isbn"
        self.upc = "upc"
        self.diamondCode = "diamondCode"
        self.ean = "ean"
        self.issn = "issn"
        self.format = "format"
        self.pageCount = 1
        self.textObjects = []
        self.resourceURI = "resourceURI"
        self.urls = []
        self.series = Series.empty
        self.variants = []
        self.collections = []
        self.collectedIssues = []
        self.dates = []
        self.prices = []
        self.thumbnail = Thumbnail(path: "", thumbnailExtension: "")
        self.images = []
        self.creators = ListOfEntitiesOfItemModel(available: 0, collectionURI: "", items: [], returned: 0)
        self.characters = ListOfEntitiesOfItemModel(available: 0, collectionURI: "", items: [], returned: 0)
        self.stories = ListOfEntitiesOfItemModel(available: 0, collectionURI: "", items: [], returned: 0)
        self.events = ListOfEntitiesOfItemModel(available: 0, collectionURI: "", items: [], returned: 0)
    }
}

struct CreatorsModel: Codable, Item {
    let id: Int
    let firstName, middleName, lastName, suffix: String
    let fullName: String
    let modified: String
    let thumbnail: Thumbnail?
    let resourceURI: String
    let comics, series: ListOfEntitiesOfItemModel<ComicsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let events: ListOfEntitiesOfItemModel<ComicsItem>
    let urls: [URLElement]
    
    init(
        id: Int, firstName: String, middleName: String, lastName: String, suffix: String, fullName: String,
        modified: String, thumbnail: Thumbnail?, resourceURI: String,
        comics: ListOfEntitiesOfItemModel<ComicsItem>, series: ListOfEntitiesOfItemModel<ComicsItem>,
        stories: ListOfEntitiesOfItemModel<StoriesItem>, events: ListOfEntitiesOfItemModel<ComicsItem>,
        urls: [URLElement]
    ) {
        self.id = id
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.suffix = suffix
        self.fullName = fullName
        self.modified = modified
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "entity", thumbnailExtension: "")
        }
        self.resourceURI = resourceURI
        self.comics = comics
        self.series = series
        self.stories = stories
        self.events = events
        self.urls = urls
    }
}

struct EventsModel: Codable, Item {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let urls: [URLElement]
    let modified: String
    let start, end: String?
    let thumbnail: Thumbnail?
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let characters: ListOfEntitiesOfItemModel<ComicsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let comics, series: ListOfEntitiesOfItemModel<ComicsItem>
    let next, previous: Series?
    
    init(
        id: Int,  title: String, description: String?, resourceURI: String, urls: [URLElement], modified: String,
        start: String?, end: String?, thumbnail: Thumbnail?,  creators: ListOfEntitiesOfItemModel<CreatorsItem>,
        characters: ListOfEntitiesOfItemModel<ComicsItem>, stories: ListOfEntitiesOfItemModel<StoriesItem>,
        comics: ListOfEntitiesOfItemModel<ComicsItem>, series: ListOfEntitiesOfItemModel<ComicsItem>,
        next: Series?, previous: Series?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.resourceURI = resourceURI
        self.urls = urls
        self.modified = modified
        self.start = start
        self.end = end
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "entity", thumbnailExtension: "")
        }
        self.creators = creators
        self.characters = characters
        self.stories = stories
        self.comics = comics
        self.series = series
        self.next = next
        self.previous = previous
    }
}

struct SeriesModel: Codable, Item {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let urls: [URLElement]
    let startYear, endYear: Int
    let rating: String
    let type: String
    let modified: String
    let thumbnail: Thumbnail?
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let stories: ListOfEntitiesOfItemModel<StoriesItem>
    let characters, comics, events: ListOfEntitiesOfItemModel<ComicsItem>
    let next, previous: Series?
    
    init(
        id: Int, title: String, description: String?, resourceURI: String, urls: [URLElement], startYear: Int,
        endYear: Int, rating: String, type: String, modified: String, thumbnail: Thumbnail?,
        creators: ListOfEntitiesOfItemModel<CreatorsItem>, stories: ListOfEntitiesOfItemModel<StoriesItem>,
        characters: ListOfEntitiesOfItemModel<ComicsItem>, comics: ListOfEntitiesOfItemModel<ComicsItem>,
        events: ListOfEntitiesOfItemModel<ComicsItem>, next: Series?, previous: Series?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.resourceURI = resourceURI
        self.urls = urls
        self.startYear = startYear
        self.endYear = endYear
        self.rating = rating
        self.type = type
        self.modified = modified
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "entity", thumbnailExtension: "")
        }
        self.creators = creators
        self.stories = stories
        self.characters = characters
        self.comics = comics
        self.events = events
        self.next = next
        self.previous = previous
    }
}

struct StoriesModel: Codable, Item {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let type: String
    let modified: String
    let thumbnail: Thumbnail?
    let creators: ListOfEntitiesOfItemModel<CreatorsItem>
    let events, characters, series, comics: ListOfEntitiesOfItemModel<ComicsItem>
    let originalIssue: Series
    
    init(
        id: Int, title: String, description: String?,  resourceURI: String, type: String, modified: String,
        thumbnail: Thumbnail?, creators: ListOfEntitiesOfItemModel<CreatorsItem>,
        events: ListOfEntitiesOfItemModel<ComicsItem>, characters: ListOfEntitiesOfItemModel<ComicsItem>,
        series: ListOfEntitiesOfItemModel<ComicsItem>, comics: ListOfEntitiesOfItemModel<ComicsItem>,
        originalIssue: Series
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.resourceURI = resourceURI
        self.type = type
        self.modified = modified
        
        if let thumbnail = thumbnail, thumbnail.path != imageNotAvailable {
            self.thumbnail = thumbnail
        } else {
            self.thumbnail = Thumbnail(path: "entity", thumbnailExtension: "")
        }
        self.creators = creators
        self.events = events
        self.characters = characters
        self.series = series
        self.comics = comics
        self.originalIssue = originalIssue
    }
}
