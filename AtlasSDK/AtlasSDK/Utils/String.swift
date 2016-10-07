//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    init?(contentsOfFile url: NSURL, encoding: NSStringEncoding = NSUTF8StringEncoding) {
        guard let data = NSData(contentsOfURL: url) else { return nil }
        let contents = NSString(data: data, encoding: encoding)
        self.init(contents)
    }

    var whiteCharactersFreeString: String {
        let string = componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()).joinWithSeparator("")
        return string.stringByReplacingOccurrencesOfString("  ", withString: "")
    }

    var range: NSRange {
        return NSRange(location: 0, length: characters.count)
    }

    var bracketsFree: String {
        let regex = try? NSRegularExpression(pattern: "\\([^\\)]*\\)", options: .CaseInsensitive)
        return regex?.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: "") ?? ""
    }

}
