//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Brand {

    public let name: String

}

extension Brand: JSONInitializable {

    init?(json: JSON) {
        guard let name = json["name"].string else { return nil }
        self.name = name
    }

}
