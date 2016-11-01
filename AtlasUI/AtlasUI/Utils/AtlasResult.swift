//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        switch self {
        case .failure(let error):
            guard (error as? AtlasUserError) != AtlasUserError.userCancelled else {
                AtlasLogger.logError(error)
                return nil
            }

            if fullScreen {
                UserMessage.displayErrorFullScreen(error)
            } else {
                UserMessage.displayError(error)
            }
            return nil
        case .success(let data):
            return data
        }
    }

}
