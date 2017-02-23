//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension Data {

    init?(withJSONObject json: [String: Any]?, options: JSONSerialization.WritingOptions = []) throws {
        guard let json = json else { return nil }
        do {
            self = try JSONSerialization.data(withJSONObject: json, options: options)
        } catch let e {
            AtlasLogger.logError(e)
            throw e
        }
    }

}
