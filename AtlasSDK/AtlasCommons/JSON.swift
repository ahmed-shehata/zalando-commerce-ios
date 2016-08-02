//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension JSON {

    public static func parse(contentsOfFile path: String) -> JSON {
        do {
            return parse(try String(contentsOfFile: path))
        } catch let e {
            logError(e)
            return JSON(NSNull())
        }
    }

}
