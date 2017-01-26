//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias AuthorizationToken = String
typealias AuthorizationCompletion = (AtlasResult<AuthorizationToken>) -> Void

struct OAuth2AuthorizationHandler {

    func authorize(completion: @escaping AuthorizationCompletion) {
        guard let loginURL = AtlasAPIClient.shared?.config.loginURL else { return }
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(AtlasLoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = OAuth2LoginViewController(loginURL: loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)

        navigationController.modalPresentationStyle = .overCurrentContext
        topViewController.present(navigationController, animated: true, completion: nil)
    }

}
