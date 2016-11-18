//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Locale {

    func validCountryCode(fallbackCode: String = "") -> String {
        if #available(iOS 10.0, *) {
            return (self as NSLocale).countryCode ?? fallbackCode
        } else {
            return (self as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? fallbackCode
        }
    }

}
