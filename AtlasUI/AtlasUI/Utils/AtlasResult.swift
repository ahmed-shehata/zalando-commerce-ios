//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

enum ErrorBehaviour {

    case GeneralError
    case CancelCheckout(viewController: UIViewController)

}

extension AtlasResult {

    internal func success(errorBehaviour errorBehaviour: ErrorBehaviour = .GeneralError) -> T? {
        switch self {
        case .failure(let error):
            displayError(error, errorBehaviour: errorBehaviour)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType, errorBehaviour: ErrorBehaviour) {
        switch errorBehaviour {
        case .GeneralError:
            UserMessage.unclasifiedError(error)
            UserMessage.unclasifiedError(error)
        case .CancelCheckout(let viewController):
            viewController.dismissViewControllerAnimated(true) {
                UserMessage.unclasifiedError(error)
            }
        }
    }

}
