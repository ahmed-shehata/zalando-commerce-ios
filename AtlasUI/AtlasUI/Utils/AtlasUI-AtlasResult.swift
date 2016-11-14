//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        switch self {
        case .failure(let error):
            switch error {
            case AtlasAPIError.unauthorized(let repeatCall):
                let authorizationHandler = OAuth2AuthorizationHandler()
                authorizationHandler.authorize { result in
                    guard let accessToken = result.process(forceFullScreenError: fullScreen) else { return }
                    APIAccessToken.store(accessToken)
                    UserMessage.displayLoader { hideLoader in
                        repeatCall {
                            hideLoader()
                        }
                    }
                }
                return nil

            default:
                if fullScreen {
                    UserMessage.displayErrorFullScreen(error)
                } else {
                    UserMessage.displayError(error)
                }
            }
            return nil
        case .success(let data):
            return data
        }
    }

}
