//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI

extension CNPostalAddress {

    var streetLine1: String? {
        return street.components(separatedBy: "\n").first
    }

    var streetLine2: String? {
        let streetComponents = street.components(separatedBy: "\n")
        return streetComponents.count > 1 && !streetComponents[1].isEmpty ? streetComponents[1] : nil
    }

}
