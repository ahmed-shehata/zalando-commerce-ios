//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Media {

    public let mediaItems: [MediaItem]

    public var firstImage: MediaItem? {
        return mediaItems.first { $0.itemType == .image }
    }

}

extension Media {

    public struct MediaItem {
        public let order: Int
        public let itemType: MediaItemType
        public let catalogURL: URL
        public let catalogHDURL: URL
        public let detailURL: URL
        public let detailHDURL: URL
        public let largeURL: URL
        public let largeHDURL: URL
    }

    public enum MediaItemType: String {
        case image = "IMAGE"
        case image360 = "IMAGE_360"
        case image360Preview = "IMAGE_360_PREVIEW"
        case videoThumbnail = "VIDEO_THUMBNAIL"
        case videoHD = "VIDEO_HD"
        case unknown = "UNKNOWN"
    }

}

extension Media: JSONInitializable {

    init?(json: JSON) {
        self.mediaItems = json["media_items"].jsons.flatMap { Media.MediaItem(json: $0) }
    }

}

extension Media.MediaItem: JSONInitializable {

    init?(json: JSON) {
        guard let order = json["order"].int,
            let typeValue = json["type"].string,
            let catalogURL = json["catalog"].url,
            let catalogHDURL = json["catalog_hd"].url,
            let detailURL = json["detail"].url,
            let detailHDURL = json["detail_hd"].url,
            let largeURL = json["large"].url,
            let largeHDURL = json["large_hd"].url
            else { return nil }

        self.order = order
        self.itemType = Media.MediaItemType(rawValue: typeValue) ?? .unknown
        self.catalogURL = catalogURL
        self.catalogHDURL = catalogHDURL
        self.detailURL = detailURL
        self.detailHDURL = detailHDURL
        self.largeURL = largeURL
        self.largeHDURL = largeHDURL
    }

}
