//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

// TODO: don't pass it from controller to controller. Use Injector
protocol LocalizerProviderType: class {

    var localizer: Localizer { get }

}

extension LocalizerProviderType {

    func loc(text: String, _ formatArguments: CVarArgType?...) -> String {
        return localizer.localizedString(text, formatArguments: formatArguments)
    }

}
