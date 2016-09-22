//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct OAuth2AuthorizationHandler: AuthorizationHandler {

    private let loginURL: NSURL

    init(loginURL: NSURL) {
        self.loginURL = loginURL
    }

    func authorize(completion: AuthorizationCompletion) {
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(LoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = OAuth2LoginViewController(loginURL: self.loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)

        Async.main {
            navigationController.modalPresentationStyle = .OverCurrentContext
            topViewController.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

}
