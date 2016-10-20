//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSLocale {

    func stringForKey(key: String) -> String {
        return self.objectForKey(key) as? String ?? ""
    }

    // countryCode and languageCode were introduced with iOS 10,
    // but there's no compile-time check iOS version
    #if swift(>=2.3)
    #else
        var countryCode: String {
            return self.stringForKey(NSLocaleCountryCode)
        }

        var languageCode: String {
            return self.stringForKey(NSLocaleLanguageCode)
        }
    #endif

}
