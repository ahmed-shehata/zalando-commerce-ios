//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        switch self {
        case .failure(let error):
            guard let userError = error as? AtlasUserError where userError != AtlasUserError.userCancelled else {
                print("SWALLOWED: ", error)
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
