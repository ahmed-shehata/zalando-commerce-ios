//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        switch self {
        case .failure(let error):
            UserMessage.displayError(error, forceFullScreenError: fullScreen)
            return nil
        case .success(let data):
            return data
        }
    }

}
