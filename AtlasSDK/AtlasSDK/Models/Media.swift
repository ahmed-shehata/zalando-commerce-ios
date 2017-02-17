//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Media {

    public let images: [Image]

}

extension Media {

    public struct Image {
        public let order: Int
        public let catalogURL: URL
        public let catalogHDURL: URL
        public let detailURL: URL
        public let detailHDURL: URL
        public let largeURL: URL
        public let largeHDURL: URL
    }

}

extension Media: JSONInitializable {

    init?(json: JSON) {
        self.images = json["images"].jsons.flatMap { Media.Image(json: $0) }
    }

}

extension Media.Image: JSONInitializable {

    init?(json: JSON) {
        guard let order = json["order"].int,
            let catalogURL = json["catalog"].url,
            let catalogHDURL = json["catalog_hd"].url,
            let detailURL = json["detail"].url,
            let detailHDURL = json["detail_hd"].url,
            let largeURL = json["large"].url,
            let largeHDURL = json["large_hd"].url
            else { return nil }
        self.order = order
        self.catalogURL = catalogURL
        self.catalogHDURL = catalogHDURL
        self.detailURL = detailURL
        self.detailHDURL = detailHDURL
        self.largeURL = largeURL
        self.largeHDURL = largeHDURL
    }

}
