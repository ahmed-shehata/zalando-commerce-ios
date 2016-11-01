//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSDateFormatter {

    convenience init(dateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZone: NSTimeZone? = nil) {
        self.init()
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
        self.timeZone = timeZone
        self.dateFormat = dateFormat
    }

}

class RFC3339DateFormatter: NSDateFormatter {

    private let noMillisecondsFormatter: NSDateFormatter

    override init() {
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let timeZone = NSTimeZone(abbreviation: "GMT")
        self.noMillisecondsFormatter = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ",
            localeIdentifier: locale.localeIdentifier,
            timeZone: timeZone)
        super.init()
        self.locale = locale
        self.timeZone = timeZone
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func dateFromString(string: String?) -> NSDate? {
        guard let string = string else { return nil }
        return super.dateFromString(string) ?? noMillisecondsFormatter.dateFromString(string)
    }
}
