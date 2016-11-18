//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var whiteCharactersFreeString: String {
        let string = components(separatedBy: CharacterSet.newlines).joined(separator: "")
        return string.replacingOccurrences(of: "  ", with: "")
    }

}
