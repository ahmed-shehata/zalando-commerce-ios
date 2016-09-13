//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct Delivery {

    public let earliest: NSDate?
    public let latest: NSDate

}

extension Delivery: JSONInitializable {

    private struct Keys {
        static let earliest = "earliest"
        static let latest = "latest"
    }

    init?(json: JSON) {
        guard let latest = RFC3339DateFormatter().dateFromString(json[Keys.latest].string)
        else { return nil }
        let earliest = RFC3339DateFormatter().dateFromString(json[Keys.latest].string)

        self.init(earliest: earliest, latest: latest)
    }
}
