//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    func whitespaceCompacted() -> String {
        let string = components(separatedBy: CharacterSet.newlines).joined(separator: "")
        return string.replacingOccurrences(of: "  ", with: "")
    }

    init?(withJSONObject json: [String: Any]?,
          options: JSONSerialization.WritingOptions = [.prettyPrinted],
          encoding: Encoding = .utf8) {
        guard let json = json,
            let data = try? Data(withJSONObject: json, options: options),
            let jsonData = data
            else { return nil }
        self.init(data: jsonData, encoding: encoding)
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

