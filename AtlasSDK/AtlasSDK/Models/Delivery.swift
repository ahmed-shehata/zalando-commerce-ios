//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct Delivery {

    public let earliest: Date?
    public let latest: Date

}

extension Delivery: JSONInitializable {

    fileprivate struct Keys {
        static let earliest = "earliest"
        static let latest = "latest"
    }

    init?(json: JSON) {
        guard let latest = RFC3339DateFormatter().date(from: json[Keys.latest].string)
        else { return nil }
        let earliest = RFC3339DateFormatter().date(from: json[Keys.earliest].string)

        self.init(earliest: earliest, latest: latest)
    }

}
