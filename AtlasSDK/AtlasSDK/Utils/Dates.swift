//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension DateFormatter {

    convenience init(dateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZone: TimeZone? = nil) {
        self.init()
        self.locale = Locale(identifier: localeIdentifier)
        self.timeZone = timeZone
        self.dateFormat = dateFormat
    }

}

class RFC3339DateFormatter: DateFormatter {

    fileprivate let noMillisecondsFormatter: DateFormatter

    override init() {
        let locale = Locale(identifier: "en_US_POSIX")
        let timeZone = TimeZone(abbreviation: "GMT")
        self.noMillisecondsFormatter = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ",
            localeIdentifier: locale.identifier,
            timeZone: timeZone)
        super.init()
        self.locale = locale
        self.timeZone = timeZone
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        return super.date(from: string) ?? noMillisecondsFormatter.date(from: string)
    }
}
