//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

enum AtlasUIError {
    case GeneralError(userMessage: UserMessage)
    case CancelCheckout(userMessage: UserMessage, viewController: UIViewController)
}

extension AtlasResult {

    internal func success(errorHandlingType errorHandling: AtlasUIError) -> T? {
        switch self {
        case .failure(let error):
            displayError(error, errorHandling: errorHandling)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType, errorHandling: AtlasUIError) {
        switch errorHandling {
        case .GeneralError(let userMessage):
            userMessage.generalError()
        case .CancelCheckout(let userMessage, let viewController):
            viewController.dismissViewControllerAnimated(true) {
                userMessage.generalError()
            }
        }
    }

}
