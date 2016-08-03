//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension String {

    var loc: String {
        return Localizer.sharedLocalizer?.localizedString(self) ?? self
    }

    func loc(formatArguments: CVarArgType...) -> String {
        return Localizer.sharedLocalizer?.localizedString(self, formatArguments: formatArguments) ?? self
    }

}
