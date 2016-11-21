//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    var newlinesRemoved: String {
        let string = components(separatedBy: CharacterSet.newlines).joined(separator: "")
        return string.replacingOccurrences(of: "  ", with: "")
    }

    init?(withJSONObject json: [String: AnyObject]?,
          options: JSONSerialization.WritingOptions = [.prettyPrinted],
          encoding: Encoding = .utf8) {
        guard let json = json,
            let data = try? Data(withJSONObject: json, options: options),
            let jsonData = data
            else { return nil }
        self.init(data: jsonData, encoding: encoding)
    }

}
