//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var length: Int {
        return characters.count
    }

    func onelined() -> String {
        return replacingOccurrences(of: "\n", with: " ")
    }

    func range() -> NSRange {
        return NSRange(location: 0, length: (self as NSString).length)
    }

    func matches(pattern: String, options: NSRegularExpression.Options = .caseInsensitive) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: options)
        return regex?.firstMatch(in: self, options: [], range: self.range()) != nil
    }

}
