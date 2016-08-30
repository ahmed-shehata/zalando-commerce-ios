//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

}
