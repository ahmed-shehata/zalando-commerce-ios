//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        switch self {
        case .failure(let error):
            guard (error as? AtlasUserError) != AtlasUserError.userCancelled else {
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

// TODO: Handle AuthorizationHandler
//guard let authorizationHandler = try? AtlasUI.provide() as AuthorizationHandler else {
//                        return completion(.failure(error))
//                    }
//                    authorizationHandler.authorize { result in
//                        switch result {
//                        case .failure(let error):
//                            completion(.failure(error))
//                        case .success(let accessToken):
//                            APIAccessToken.store(accessToken)
//                            self.execute(completion)
//                        }
//                    }
// AtlasUI.register { OAuth2AuthorizationHandler(loginURL: client.config.loginURL) as AuthorizationHandler }
