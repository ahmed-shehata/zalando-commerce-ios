//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

let ISO8601DateFormatter = NSDateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")

extension NSDateFormatter {

    convenience init(dateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZone: String = "GMT") {
        self.init()
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
        self.timeZone = NSTimeZone(abbreviation: timeZone)
        self.dateFormat = dateFormat
    }

}

extension String {

    init?(fromDate date: NSDate?, formatter: NSDateFormatter) {
        guard let d = date else {
            return nil
        }
        self = formatter.stringFromDate(d)
    }

}

extension NSDate {

    convenience init?(object: AnyObject?, formatter: NSDateFormatter) {
        guard let string = object as? String, date = formatter.dateFromString(string) else {
            return nil
        }
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }

}
