//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

struct OAuth2AuthorizationHandler {

    func authorize(completion: @escaping ResultCompletion<AuthorizationToken>) {
        guard let loginURL = Config.shared?.loginURL else { return }
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(LoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = OAuth2LoginViewController(loginURL: loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)

        navigationController.modalPresentationStyle = .overCurrentContext
        topViewController.present(navigationController, animated: true, completion: nil)
    }

}
