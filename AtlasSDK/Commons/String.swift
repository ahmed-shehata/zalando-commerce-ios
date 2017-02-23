//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }

    func whitespaceCompacted() -> String {
        let string = components(separatedBy: CharacterSet.newlines).joined(separator: "")
        return string.replacingOccurrences(of: "  ", with: "")
    }

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

postfix operator ~?
infix operator ~?

postfix func ~?<T> (val: T?) -> String {
    if let val = val {
        return String(describing: val)
    } else {
        return ""
    }
}

func ~?<T> (val: T?, fallback: String = "") -> String {
    if let val = val {
        return String(describing: val)
    } else {
        return fallback
    }
}

