//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

let ISO8601DateFormatter = DoubleFormatDateFormatter(defaultDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ",
    backupDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")

extension NSDateFormatter {

    convenience init(dateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZoneName: String = "GMT") {
        self.init(dateFormat: dateFormat, localeIdentifier: localeIdentifier, timeZone: NSTimeZone(abbreviation: timeZoneName))
    }

    convenience init(dateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZone: NSTimeZone? = nil) {
        self.init()
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
        self.timeZone = timeZone
        self.dateFormat = dateFormat
    }

}

struct DoubleFormatDateFormatter {

    let defaultFormatter: NSDateFormatter
    let backupFormatter: NSDateFormatter

    init(defaultDateFormat: String, backupDateFormat: String, localeIdentifier: String = "en_US_POSIX", timeZoneName: String = "GMT") {
        self.defaultFormatter = NSDateFormatter(dateFormat: defaultDateFormat,
            localeIdentifier: localeIdentifier,
            timeZoneName: timeZoneName)
        self.backupFormatter = NSDateFormatter(dateFormat: backupDateFormat, localeIdentifier: localeIdentifier, timeZoneName: timeZoneName)
    }

    func dateFromString(string: String?) -> NSDate? {
        guard let string = string else { return nil }
        return defaultFormatter.dateFromString(string) ?? backupFormatter.dateFromString(string)
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
