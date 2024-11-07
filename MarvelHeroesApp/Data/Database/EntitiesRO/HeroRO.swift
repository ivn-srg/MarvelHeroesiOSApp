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
}

final class StoriesInfoRO: EmbeddedObject {
    @Persisted var available: Int
    @Persisted var collectionURI: String
    @Persisted var items: List<StoriesItemRO>
    @Persisted var returned: Int
}

final class StoriesItemRO: EmbeddedObject {
    @Persisted var resourceURI: String
    @Persisted var name: String
    @Persisted var type: String
}

final class ComicsItemRO: EmbeddedObject {
    @Persisted var resourceURI: String
    @Persisted var name: String
}

final class URLElementRO: EmbeddedObject {
    @Persisted var type: String
    @Persisted var url: String
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
