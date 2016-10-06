//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct PriceChangedError: UserPresentable {

    let newPrice: NSDecimalNumber

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.priceChanged.title")
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.priceChanged.message: %@", Localizer.price(newPrice))
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

}
