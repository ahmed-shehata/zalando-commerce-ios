//
//  Copyright © 2016 Zalando SE. All rights reserved.
//


public struct Delivery {
    public let earliest: String?
    public let latest: String
}

extension Delivery: JSONInitializable {

    private struct Keys {
        static let earliest = "earliest"
        static let latest = "latest"
    }

    init?(json: JSON) {
        guard let latest = json[Keys.latest].string else { return nil }
        self.init(earliest: json[Keys.earliest].string, latest: latest)
    }
}
