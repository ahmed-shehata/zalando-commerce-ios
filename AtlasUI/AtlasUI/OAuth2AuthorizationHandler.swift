//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public typealias AuthorizationToken = String
public typealias AuthorizationCompletion = AtlasResult<AuthorizationToken> -> Void

public struct OAuth2AuthorizationHandler {

    public init() {

    }

    public func authorize(completion: AuthorizationCompletion) {
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
