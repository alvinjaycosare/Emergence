import Gloss
import ISO8601DateFormatter

struct Artwork: Artworkable {
    let id: String
    let title: String
    let date: String
    let medium: String

    let artists: [Artistable]?
    let culturalMarker: String?
    let images: [Imageable]

    let dimensionsInches: String?
    let dimensionsCM: String?

    lazy var defaultImage: Imageable? = {
        let defaultImages = self.images.filter({ $0.isDefault })
        return defaultImages.isNotEmpty ? defaultImages.first : self.images.first
    }()

    func titleWithDate() -> NSAttributedString {
        return NSAttributedString.artworkTitleAndDateString(title, dateString: date, fontSize: 30)
    }

    func oneLinerArtist() -> String? {
        if let artist = artists?.first {
            return artist.name
        }
        return culturalMarker
    }
}

extension Artwork: Decodable {
    init?(json: JSON) {

        guard
            let idValue: String = "id" <~~ json,
            let titleValue: String = "title" <~~ json,
            let dateValue: String = "date" <~~ json,
            let mediumValue: String = "medium" <~~ json
        else {
            return nil
        }

        id = idValue
        title = titleValue
        medium = mediumValue
        date = dateValue
        culturalMarker = "cultural_marker" <~~ json

        if let dimensions:JSON = "dimensions" <~~ json {
            dimensionsCM = "cm" <~~ dimensions
            dimensionsInches = "in" <~~ dimensions
        } else {
            dimensionsInches = nil
            dimensionsCM = nil
        }

        if let artistsValue: [Artist] = "artists" <~~ json {
            artists = artistsValue.map { return $0 as Artistable }
        } else {
            artists = []
        }

        if let imagesValue: [Image] = "images" <~~ json {
           images = imagesValue.map { return $0 as Imageable }
        } else {
            images = []
        }
    }
}

