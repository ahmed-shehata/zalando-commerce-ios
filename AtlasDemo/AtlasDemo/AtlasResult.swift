//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI

extension AtlasResult {

    func process() -> T? {
        switch self {
        case .failure(let error):
            switch error {
            case AtlasAPIError.unauthorized(let repeatCall):
                let authorizationHandler = OAuth2AuthorizationHandler()
                authorizationHandler.authorize { result in
                    guard let accessToken = result.process() else { return }
                    APIAccessToken.store(accessToken)
                    repeatCall {}
                }
                return nil

            default:
                displayError(error)
            }

            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType) {
        var message: String?
        let unclassifiedMessage = "Something went wrong.\nWe are fixing the issue.\nPlease come back later"

        switch error {
        case AtlasAPIError.noInternet: message = "Please check you internet connection"
        case AtlasAPIError.unauthorized: message = "Access denied"
        case AtlasAPIError.nsURLError(_, let details): message = details
        case AtlasAPIError.http(_, let details): message = details
        case AtlasAPIError.backend(_, _, _, let details): message = details
        case AtlasLoginError.accessDenied: message = "Access denied"
        case AtlasLoginError.requestFailed(let error): message = error?.localizedDescription
        case ArticlesError.Error(let error): message = (error as NSError).localizedDescription
        default: message = unclassifiedMessage
        }

        showMessage(title: "Oops", message: message ?? unclassifiedMessage)
    }

    private func showMessage(title title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        dispatch_async(dispatch_get_main_queue()) {
            let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
            navigationController?.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
