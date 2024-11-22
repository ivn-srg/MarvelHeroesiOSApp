import Foundation
import RealmSwift

// MARK: - Main Objects
final class HeroRO: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var heroDescription: String = ""
    @Persisted var modified: String = ""
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var resourceURI: String = ""
    @Persisted var comics: HeroEntitiesInfoRO?
    @Persisted var series: HeroEntitiesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var events: HeroEntitiesInfoRO?
    @Persisted var urls: List<URLElementRO>
    
    override public static func primaryKey() -> String? {
        "id"
    }
    
    convenience init(heroData: HeroItemModel) {
        self.init()
        self.id = heroData.id
        self.name = heroData.name
        self.heroDescription = heroData.description ?? ""
        self.thumbnail = ThumbnailRO(entityImageData: heroData.thumbnail)
        self.resourceURI = heroData.resourceURI
        self.comics = HeroEntitiesInfoRO(comicsModel: heroData.comics)
        self.series = HeroEntitiesInfoRO(comicsModel: heroData.series)
        self.stories = StoriesInfoRO(storiesModel: heroData.stories)
        self.events = HeroEntitiesInfoRO(comicsModel: heroData.events)
        
        let listOfUrls = List<URLElementRO>()
        for urlItem in heroData.urls {
            listOfUrls.append(URLElementRO(type: urlItem.type, url: urlItem.url))
        }
        self.urls = listOfUrls
    }
}

// MARK: - Comics
final class ComicsItemModelRO: Object {
    @Persisted var id: Int
    @Persisted var digitalId: Int?
    @Persisted var title: String
    @Persisted var issueNumber: Int?
    @Persisted var variantDescription: String?
    @Persisted var comicsDescription: String
    @Persisted var modified: String
    @Persisted var isbn: String?
    @Persisted var upc: String?
    @Persisted var diamondCode: String?
    @Persisted var ean: String?
    @Persisted var issn: String?
    @Persisted var format: String?
    @Persisted var pageCount: Int
    @Persisted var textObjects: List<TextObjectRO>
    @Persisted var resourceURI: String
    @Persisted var urls: List<URLElementRO>
    @Persisted var variants: List<HeroEntityItemRO>
    @Persisted var collections: List<HeroEntityItemRO>
    @Persisted var collectedIssues: List<HeroEntityItemRO>
    @Persisted var dates: List<DateElementRO>
    @Persisted var prices: List<PriceRO>
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var images: List<ThumbnailRO>
    @Persisted var creators: CreatorsInfoRO?
    @Persisted var series: HeroEntityItemRO?
    @Persisted var characters: HeroEntitiesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var events: HeroEntitiesInfoRO?
    
    override public static func primaryKey() -> String? {
        "id"
    }

    override init() {
        self.id = 0
        self.digitalId = 0
        self.title = "Title cell"
        self.issueNumber = 0
        self.variantDescription = "variantDescription"
        self.modified = "modified"
        self.isbn = "isbn"
        self.upc = "upc"
        self.diamondCode = "diamondCode"
        self.ean = "ean"
        self.issn = "issn"
        self.format = "format"
        self.pageCount = 1
        self.textObjects = List<TextObjectRO>()
        self.resourceURI = "resourceURI"
        self.urls = List<URLElementRO>()
        self.series = HeroEntityItemRO()
        self.variants = List<HeroEntityItemRO>()
        self.collections = List<HeroEntityItemRO>()
        self.collectedIssues = List<HeroEntityItemRO>()
        self.dates = List<DateElementRO>()
        self.prices = List<PriceRO>()
        self.thumbnail = ThumbnailRO()
        self.images = List<ThumbnailRO>()
        self.creators = CreatorsInfoRO()
        self.characters = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = HeroEntitiesInfoRO()
    }
}

extension ComicsItemModelRO {
    convenience init(comicsData: ComicsItemModel) {
        self.init()
        self.id = comicsData.id
        self.digitalId = comicsData.digitalId
        self.title = comicsData.title
        self.issueNumber = comicsData.issueNumber
        self.variantDescription = comicsData.variantDescription
        self.modified = comicsData.modified
        self.isbn = comicsData.isbn
        self.upc = comicsData.upc
        self.diamondCode = comicsData.diamondCode
        self.ean = comicsData.ean
        self.issn = comicsData.issn
        self.format = comicsData.format
        self.pageCount = comicsData.pageCount
        self.textObjects = List<TextObjectRO>()
        self.resourceURI = comicsData.resourceURI
        self.urls = List<URLElementRO>()
        self.variants = List<HeroEntityItemRO>()
        self.collections = List<HeroEntityItemRO>()
        self.collectedIssues = List<HeroEntityItemRO>()
        self.dates = List<DateElementRO>()
        self.prices = List<PriceRO>()
        self.thumbnail = ThumbnailRO()
        self.images = List<ThumbnailRO>()
        self.creators = CreatorsInfoRO(creatorsModel: comicsData.creators)
        self.series = HeroEntityItemRO()
        self.characters = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = HeroEntitiesInfoRO()
    }
}

// MARK: - Creator
final class CreatorsModelRO: Object {
    @Persisted var id: Int
    @Persisted var firstName: String
    @Persisted var middleName: String
    @Persisted var lastName: String
    @Persisted var suffix: String
    @Persisted var fullName: String
    @Persisted var modified: String
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var resourceURI: String
    @Persisted var comics: HeroEntitiesInfoRO?
    @Persisted var series: HeroEntitiesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var events: HeroEntitiesInfoRO?
    @Persisted var urls: List<URLElementRO>
    
    override public static func primaryKey() -> String? {
        "id"
    }

    override init() {
        self.id = 0
        self.firstName = "firstName"
        self.middleName = "middleName"
        self.lastName = "lastName"
        self.suffix = "suffix"
        self.fullName = "fullName"
        self.modified = "modified"
        self.thumbnail = ThumbnailRO()
        self.resourceURI = "resourceURI"
        self.comics = HeroEntitiesInfoRO()
        self.series = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = HeroEntitiesInfoRO()
        self.urls = List<URLElementRO>()
    }
}

extension CreatorsModelRO {
    convenience init(creatorModel: CreatorsModel) {
        self.init()
        self.id = creatorModel.id
        self.firstName = creatorModel.firstName
        self.middleName = creatorModel.middleName
        self.lastName = creatorModel.lastName
        self.suffix = creatorModel.suffix
        self.fullName = creatorModel.fullName
        self.modified = creatorModel.modified
        self.thumbnail = ThumbnailRO(entityImageData: creatorModel.thumbnail)
        self.resourceURI = creatorModel.resourceURI
        self.comics = HeroEntitiesInfoRO(comicsModel: creatorModel.comics)
        self.series = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = HeroEntitiesInfoRO()
        self.urls = List<URLElementRO>()
    }
}

// MARK: - Events
final class EventModelRO: Object {
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var eventDescription: String
    @Persisted var resourceURI: String
    @Persisted var urls: List<URLElementRO>
    @Persisted var modified: String
    @Persisted var start: String?
    @Persisted var end: String?
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var creators: CreatorsInfoRO?
    @Persisted var characters: HeroEntitiesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var comics: HeroEntitiesInfoRO?
    @Persisted var series: HeroEntitiesInfoRO?
    @Persisted var next: HeroEntityItemRO?
    @Persisted var previous: HeroEntityItemRO?
    
    override public static func primaryKey() -> String? {
        "id"
    }

    override init() {
        self.id = 0
        self.title = "title"
        self.eventDescription = "eventDescription"
        self.resourceURI = "resourceURI"
        self.urls = List<URLElementRO>()
        self.modified = "modified"
        self.start = "start"
        self.end = "end"
        self.thumbnail = ThumbnailRO()
        self.creators = CreatorsInfoRO()
        self.characters = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.comics = HeroEntitiesInfoRO()
        self.series = HeroEntitiesInfoRO()
        self.next = HeroEntityItemRO()
        self.previous = HeroEntityItemRO()
    }
}

extension EventModelRO {
    convenience init(eventModel: EventsModel) {
        self.init()
        self.id = eventModel.id
        self.title = eventModel.title
        self.eventDescription = eventModel.description ?? ""
        self.resourceURI = eventModel.resourceURI
        
        let listOfUrls = List<URLElementRO>()
        for urlItem in eventModel.urls {
            listOfUrls.append(URLElementRO(type: urlItem.type, url: urlItem.url))
        }
        self.urls = listOfUrls
        self.modified = eventModel.modified
        self.start = eventModel.start
        self.end = eventModel.end
        self.thumbnail = ThumbnailRO(entityImageData: eventModel.thumbnail)
        self.creators = CreatorsInfoRO(creatorsModel: eventModel.creators)
        self.characters = HeroEntitiesInfoRO(comicsModel: eventModel.characters)
        self.stories = StoriesInfoRO(storiesModel: eventModel.stories)
        self.comics = HeroEntitiesInfoRO(comicsModel: eventModel.comics)
        self.series = HeroEntitiesInfoRO(comicsModel: eventModel.series)
        self.next = HeroEntityItemRO(resourceURI: eventModel.next?.resourceURI ?? "", name: eventModel.next?.name ?? "")
        self.previous = HeroEntityItemRO(resourceURI: eventModel.previous?.resourceURI ?? "", name: eventModel.previous?.name ?? "")
    }
}

// MARK: - Series
final class SeriesModelRO: Object {
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var seriesDescription: String
    @Persisted var resourceURI: String
    @Persisted var urls: List<URLElementRO>
    @Persisted var startYear: Int
    @Persisted var endYear: Int
    @Persisted var rating: String
    @Persisted var type: String
    @Persisted var modified: String
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var creators: CreatorsInfoRO?
    @Persisted var characters: HeroEntitiesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var comics: HeroEntitiesInfoRO?
    @Persisted var events: HeroEntitiesInfoRO?
    @Persisted var next: HeroEntityItemRO?
    @Persisted var previous: HeroEntityItemRO?
    
    override public static func primaryKey() -> String? {
        "id"
    }

    override init() {
        self.id = 0
        self.title = "title"
        self.seriesDescription = "eventDescription"
        self.resourceURI = "resourceURI"
        self.urls = List<URLElementRO>()
        self.modified = "modified"
        self.startYear = 2000
        self.endYear = 2000
        self.rating = ""
        self.type = ""
        self.thumbnail = ThumbnailRO()
        self.creators = CreatorsInfoRO()
        self.characters = HeroEntitiesInfoRO()
        self.stories = StoriesInfoRO()
        self.comics = HeroEntitiesInfoRO()
        self.events = HeroEntitiesInfoRO()
        self.next = HeroEntityItemRO()
        self.previous = HeroEntityItemRO()
    }
}

extension SeriesModelRO {
    convenience init(seriesModel: SeriesModel) {
        self.init()
        self.id = seriesModel.id
        self.title = seriesModel.title
        self.seriesDescription = seriesModel.description ?? ""
        self.resourceURI = seriesModel.resourceURI
        self.rating = seriesModel.rating
        self.type = seriesModel.type
        
        let listOfUrls = List<URLElementRO>()
        for urlItem in seriesModel.urls {
            listOfUrls.append(URLElementRO(type: urlItem.type, url: urlItem.url))
        }
        self.urls = listOfUrls
        self.modified = seriesModel.modified
        self.startYear = seriesModel.startYear
        self.endYear = seriesModel.endYear
        self.thumbnail = ThumbnailRO(entityImageData: seriesModel.thumbnail)
        self.creators = CreatorsInfoRO(creatorsModel: seriesModel.creators)
        self.characters = HeroEntitiesInfoRO(comicsModel: seriesModel.characters)
        self.stories = StoriesInfoRO(storiesModel: seriesModel.stories)
        self.comics = HeroEntitiesInfoRO(comicsModel: seriesModel.comics)
        self.events = HeroEntitiesInfoRO(comicsModel: seriesModel.events)
        self.next = HeroEntityItemRO(resourceURI: seriesModel.next?.resourceURI ?? "", name: seriesModel.next?.name ?? "")
        self.previous = HeroEntityItemRO(resourceURI: seriesModel.previous?.resourceURI ?? "", name: seriesModel.previous?.name ?? "")
    }
}

// MARK: - Embedded container objects
final class CreatorsInfoRO: EmbeddedObject, GeneralDataContainerProtocol {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<CreatorsItemRO>
    @Persisted var returned: Int
    
    var itemsListToArray: [GeneralHeroItemProtocol] {
        Array(items)
    }
    
    init(available: Int, collectionURI: String, items: List<CreatorsItemRO>, returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.returned = returned
        self.items = items
    }
    
    override init() {
        self.available = 0
        self.collectionURI = ""
        self.returned = 0
        self.items = List<CreatorsItemRO>()
    }
    
    convenience init(creatorsModel: ListOfEntitiesOfItemModel<CreatorsItem>?) {
        self.init()
        guard let creatorsModel = creatorsModel else { return }
        
        self.available = creatorsModel.available
        self.collectionURI = creatorsModel.collectionURI
        self.returned = creatorsModel.returned
        
        let listOfItems = List<CreatorsItemRO>()
        for item in creatorsModel.items {
            listOfItems.append(CreatorsItemRO(resourceURI: item.resourceURI, name: item.name, role: item.role))
        }
        self.items = listOfItems
    }
}

final class HeroEntitiesInfoRO: EmbeddedObject, GeneralDataContainerProtocol {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<HeroEntityItemRO>
    @Persisted var returned: Int
    
    var itemsListToArray: [GeneralHeroItemProtocol] {
        Array(items)
    }
    
    init(available: Int, collectionURI: String, items: List<HeroEntityItemRO>, returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.returned = returned
        self.items = items
    }
    
    override init() {
        self.available = 0
        self.collectionURI = ""
        self.returned = 0
        self.items = List<HeroEntityItemRO>()
    }
    
    convenience init(comicsModel: ListOfEntitiesOfItemModel<ComicsItem>?) {
        self.init()
        guard let comicsModel = comicsModel else { return }
        
        self.available = comicsModel.available
        self.collectionURI = comicsModel.collectionURI
        self.returned = comicsModel.returned
        
        let listOfItems = List<HeroEntityItemRO>()
        for item in comicsModel.items {
            listOfItems.append(HeroEntityItemRO(resourceURI: item.resourceURI, name: item.name))
        }
        self.items = listOfItems
    }
}

final class StoriesInfoRO: EmbeddedObject, GeneralDataContainerProtocol {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<StoriesItemRO>
    @Persisted var returned: Int
    
    var itemsListToArray: [GeneralHeroItemProtocol] {
        Array(items)
    }
    
    init(available: Int, collectionURI: String, items: List<StoriesItemRO>, returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.returned = returned
        self.items = items
    }
    
    override init() {
        self.available = 0
        self.collectionURI = ""
        self.returned = 0
        self.items = List<StoriesItemRO>()
    }
    
    convenience init(storiesModel: ListOfEntitiesOfItemModel<StoriesItem>?) {
        self.init()
        guard let storiesModel = storiesModel else { return }
        
        self.available = storiesModel.available
        self.collectionURI = storiesModel.collectionURI
        self.returned = storiesModel.returned
        
        let listOfItems = List<StoriesItemRO>()
        for item in storiesModel.items {
            listOfItems.append(StoriesItemRO(resourceURI: item.resourceURI, name: item.name, type: item.type))
        }
        self.items = listOfItems
    }
}

// MARK: - Embedded item objects
final class CreatorsItemRO: EmbeddedObject, GeneralHeroItemProtocol {
    @Persisted var resourceURI: String
    @Persisted var name: String
    @Persisted var role: String
    
    init(resourceURI: String, name: String, role: String) {
        self.resourceURI = resourceURI
        self.name = name
        self.role = role
    }
    
    override init() {
        self.resourceURI = "\(imageNotAvailable).jpg"
        self.name = "Hero creator"
        self.role = "creator"
    }
}

final class HeroEntityItemRO: EmbeddedObject, GeneralHeroItemProtocol {
    @Persisted var resourceURI: String
    @Persisted var name: String
    
    init(resourceURI: String, name: String) {
        self.resourceURI = resourceURI
        self.name = name
    }
    
    override init() {
        self.resourceURI = "\(imageNotAvailable).jpg"
        self.name = "Hero comics"
    }
}

final class StoriesItemRO: EmbeddedObject, GeneralHeroItemProtocol {
    @Persisted var resourceURI: String
    @Persisted var name: String
    @Persisted var type: String
    
    init(resourceURI: String, name: String, type: String) {
        self.resourceURI = resourceURI
        self.name = name
        self.type = type
    }
    
    override init() {
        self.resourceURI = ""
        self.name = ""
        self.type = ""
    }
}

final class ThumbnailRO: EmbeddedObject {
    @Persisted var path: String
    @Persisted var thumbnailExtension: String
    
    var fullPath: String {
        return "\(self.path).\(self.thumbnailExtension)"
    }
    
    convenience init(entityImageData: Thumbnail?) {
        self.init()
        
        guard let entityImageData = entityImageData else {
            self.path = ""
            self.thumbnailExtension = ""
            return
        }
        
        self.path = entityImageData.path
        self.thumbnailExtension = entityImageData.thumbnailExtension
    }
}

final class URLElementRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var url: String
    
    var urlType: EntityURLType {
        switch type {
            case "detail": return .detail
            case "wiki": return .wiki
            case "comicLink": return .comicLink
            case "inAppLink": return .inAppLink
            case "purchase": return .purchase
            case "reader": return .reader
            default: return .detail
        }
    }
    
    init(type: String, url: String) {
        self.type = type
        self.url = url
    }
    
    override init() {
        self.type = ""
        self.url = ""
    }
}

final class TextObjectRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var language: String
    @Persisted var text: String
}

final class DateElementRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var date: String
}

final class PriceRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var price: Double
}

// MARK: - Кеширование изображений
final class CachedImageData: Object {
    @Persisted var id: String = ""
    @Persisted var url: String = ""
    @Persisted var imageData: Data? = nil
    
    override public static func primaryKey() -> String? {
        "id"
    }
    
    convenience init(url: String, imageData: Data?) {
        self.init()
        self.id = UUID().uuidString
        self.url = url
        self.imageData = imageData
    }
}
