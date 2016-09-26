//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func displayErrorOrPerformSuccess(checkoutProviderType: CheckoutProviderType, successCompletion: T -> Void) {
        switch self {
        case .failure(let error):
            displayError(error, checkoutProviderType: checkoutProviderType)
        case .success(let data):
            successCompletion(data)
        }
    }

    private func displayError(error: ErrorType, checkoutProviderType: CheckoutProviderType) {
        checkoutProviderType.userMessage.show(error: error)
    }
}
