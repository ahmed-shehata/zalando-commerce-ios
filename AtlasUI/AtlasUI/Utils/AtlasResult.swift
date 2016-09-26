//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

enum AtlasUIError {
    case GeneralError
    case CancelCheckoutWithError
}

extension AtlasResult {

    internal func handleError(checkoutProviderType checkoutProviderType: CheckoutProviderType, type: AtlasUIError = .GeneralError) -> T? {
        switch self {
        case .failure(let error):
            displayError(error, checkoutProviderType: checkoutProviderType, type: type)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType, checkoutProviderType: CheckoutProviderType, type: AtlasUIError) {
        switch type {
        case .GeneralError:
            checkoutProviderType.userMessage.generalError()
        case .CancelCheckoutWithError:
            guard let viewController = checkoutProviderType as? UIViewController else { return }
            viewController.dismissViewControllerAnimated(true) {
                checkoutProviderType.userMessage.generalError()
            }
        }
    }

}
