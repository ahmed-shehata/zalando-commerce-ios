//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AuthorizationToken = String
typealias AuthorizationCompletion = AtlasResult<AuthorizationToken> -> Void

struct OAuth2AuthorizationHandler {

    init() {

    }

    func authorize(completion: AuthorizationCompletion) {
        guard let loginURL = AtlasAPIClient.instance?.config.loginURL else { return }
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(AtlasLoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = OAuth2LoginViewController(loginURL: loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)

        navigationController.modalPresentationStyle = .OverCurrentContext
        topViewController.presentViewController(navigationController, animated: true, completion: nil)
    }

}
