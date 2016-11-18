//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Data {

    init?(json: [String: AnyObject]?) throws {
        guard let json = json else { return nil }
        do {
            self = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch let e {
            AtlasLogger.logError(e)
            throw e
        }
    }

}
