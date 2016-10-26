//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSLocale {

    func stringForKey(key: String) -> String {
        return self.objectForKey(key) as? String ?? ""
    }

    var countryCode: String {
        return self.stringForKey(NSLocaleCountryCode)
    }

    var languageCode: String {
        return self.stringForKey(NSLocaleLanguageCode)
    }

}
