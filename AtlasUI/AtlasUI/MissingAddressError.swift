//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct MissingAddressError: UserPresentable {

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.missingAddress.title")
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.missingAddress.message")
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

}
