//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

import Foundation

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
        guard let latest = json[Keys.latest].date else { return nil }
        let earliest = json[Keys.earliest].date

        self.init(earliest: earliest, latest: latest)
    }

}
