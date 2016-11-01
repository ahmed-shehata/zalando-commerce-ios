//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var whiteCharactersFreeString: String {
        let string = componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).joinWithSeparator("")
        return string.stringByReplacingOccurrencesOfString("  ", withString: "")
    }

}
