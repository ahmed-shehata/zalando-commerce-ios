//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSLocale {

    func validCountryCode(defaultCode: String = "") -> String {
        if #available(iOS 10.0, *) {
            return self.countryCode ?? defaultCode
        } else {
            return self.objectForKey(NSLocaleCountryCode) as? String ?? defaultCode
        }
    }

}
