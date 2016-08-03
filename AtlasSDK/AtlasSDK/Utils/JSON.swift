//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension JSON {

    static func parse(contentsOfFile path: String) -> JSON {
        do {
            return parse(try String(contentsOfFile: path))
        } catch let e {
            AtlasLogger.logError(e)
            return JSON(NSNull())
        }
    }

}
