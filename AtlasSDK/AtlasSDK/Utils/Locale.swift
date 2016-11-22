//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Locale {

    func validRegionCode(fallbackCode: String = "") -> String {
        return self.regionCode ?? fallbackCode
    }

}
