//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension String {

    var loc: String {
        // TODO: fix localizer
        return self // Localizer.sharedLocalizer?.localizedString(self) ?? self
    }

    func loc(formatArguments: CVarArgType...) -> String {
        // TODO: fix localizer
        return self // Localizer.sharedLocalizer?.localizedString(self, formatArguments: formatArguments) ?? self
    }

}
