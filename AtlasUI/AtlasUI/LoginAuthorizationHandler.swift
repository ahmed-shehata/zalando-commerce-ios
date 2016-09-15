//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct LoginAuthorizationHandler: AtlasAuthorizationHandler {

    private let loginURL: NSURL

    init(loginURL: NSURL) {
        self.loginURL = loginURL
    }

    func authorizeTask(completion: AtlasAuthorizationCompletion) {
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(LoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = LoginViewController(loginURL: self.loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)

        Async.main {
            navigationController.modalPresentationStyle = .OverCurrentContext
            topViewController.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
}

