import Foundation
import RealmSwift

final class HeroRO: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var heroDescription: String = ""
    @Persisted var modified: String = ""
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var resourceURI: String = ""
    @Persisted var comics: ComicsInfoRO?
    @Persisted var series: ComicsInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var events: ComicsInfoRO?
    @Persisted var urls: List<URLElementRO>
    
    override public static func primaryKey() -> String? {
        "id"
    }
    
    convenience init(heroData: HeroItemModel) {
        self.init()
        self.id = heroData.id
        self.name = heroData.name
        self.heroDescription = heroData.description
        self.thumbnail = ThumbnailRO(heroImageData: heroData.thumbnail)
        self.resourceURI = heroData.resourceURI
        self.comics = ComicsInfoRO(comicsModel: heroData.comics)
        self.series = ComicsInfoRO(comicsModel: heroData.series)
        self.stories = StoriesInfoRO(storiesModel: heroData.stories)
        self.events = ComicsInfoRO(comicsModel: heroData.events)
        
        let listOfUrls = List<URLElementRO>()
        for urlItem in heroData.urls {
            listOfUrls.append(URLElementRO(type: urlItem.type, url: urlItem.url))
        }
        self.urls = listOfUrls
    }
}

final class ThumbnailRO: EmbeddedObject {
    @Persisted var path: String
    @Persisted var thumbnailExtension: String
    
    convenience init(heroImageData: Thumbnail) {
        self.init()
        self.path = heroImageData.path
        self.thumbnailExtension = heroImageData.thumbnailExtension
    }
}

final class ComicsInfoRO: EmbeddedObject {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<ComicsItemRO>
    @Persisted var returned: Int
    
    init(available: Int, collectionURI: String, items: List<ComicsItemRO>, returned: Int) {
        self.available = available
        self.collectionURI = collectionURI
        self.returned = returned
        self.items = items
    }
    
    override init() {
        self.available = 0
        self.collectionURI = ""
        self.returned = 0
        self.items = List<ComicsItemRO>()
    }
    
    convenience init(comicsModel: ListOfEntitiesOfItemModel<ComicsItem>?) {
        self.init()
        guard let comicsModel = comicsModel else { return }
        
        self.available = comicsModel.available
        self.collectionURI = comicsModel.collectionURI
        self.returned = comicsModel.returned
        
        let listOfItems = List<ComicsItemRO>()
        for item in comicsModel.items {
            listOfItems.append(ComicsItemRO(resourceURI: item.resourceURI, name: item.name))
        }
        self.items = listOfItems
    }
}

final class StoriesInfoRO: EmbeddedObject {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<StoriesItemRO>
    @Persisted var returned: Int
    
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

final class StoriesItemRO: EmbeddedObject {
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

final class ComicsItemRO: EmbeddedObject {
    @Persisted var resourceURI: String
    @Persisted var name: String
    
    init(resourceURI: String, name: String) {
        self.resourceURI = resourceURI
        self.name = name
    }
    
    override init() {
        self.resourceURI = "\(heroImageNotAvailable).jpg"
        self.name = "Hero comics"
    }
}

final class URLElementRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var url: String
    
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
    @Persisted var date: Date?
}

final class PriceRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var price: Double
}

// MARK: - Comics
final class ComicsItemModelRO: Object {
    @Persisted var id: Int
    @Persisted var digitalId: Int
    @Persisted var title: String
    @Persisted var issueNumber: Int
    @Persisted var variantDescription: String
    @Persisted var comicsDescription: String
    @Persisted var modified: String
    @Persisted var isbn: String
    @Persisted var upc: String
    @Persisted var diamondCode: String
    @Persisted var ean: String
    @Persisted var issn: String
    @Persisted var format: String
    @Persisted var pageCount: Int
    @Persisted var textObjects: List<TextObjectRO>
    @Persisted var resourceURI: String
    @Persisted var urls: List<URLElementRO>
    @Persisted var series: ComicsItemRO?
    @Persisted var variants: List<ComicsItemRO>
    @Persisted var collections: List<ComicsItemRO>
    @Persisted var collectedIssues: List<ComicsItemRO>
    @Persisted var dates: List<DateElementRO>
    @Persisted var prices: List<PriceRO>
    @Persisted var thumbnail: ThumbnailRO?
    @Persisted var images: List<ThumbnailRO>
    @Persisted var creators: StoriesInfoRO?
    @Persisted var characters: StoriesInfoRO?
    @Persisted var stories: StoriesInfoRO?
    @Persisted var events: StoriesInfoRO?
    
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
        self.series = ComicsItemRO()
        self.variants = List<ComicsItemRO>()
        self.collections = List<ComicsItemRO>()
        self.collectedIssues = List<ComicsItemRO>()
        self.dates = List<DateElementRO>()
        self.prices = List<PriceRO>()
        self.thumbnail = ThumbnailRO()
        self.images = List<ThumbnailRO>()
        self.creators = StoriesInfoRO()
        self.characters = StoriesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = StoriesInfoRO()
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
        self.series = ComicsItemRO()
        self.variants = List<ComicsItemRO>()
        self.collections = List<ComicsItemRO>()
        self.collectedIssues = List<ComicsItemRO>()
        self.dates = List<DateElementRO>()
        self.prices = List<PriceRO>()
        self.thumbnail = ThumbnailRO()
        self.images = List<ThumbnailRO>()
        self.creators = StoriesInfoRO()
        self.characters = StoriesInfoRO()
        self.stories = StoriesInfoRO()
        self.events = StoriesInfoRO()
    }
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
