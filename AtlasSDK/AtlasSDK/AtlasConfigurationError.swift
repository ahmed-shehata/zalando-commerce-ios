//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public class AtlasConfigurationError: AtlasError {

    init(status: AtlasSDK.Status, message: String? = nil) {
        super.init(code: status.rawValue, message: message ?? "\(status)")
    }

}
