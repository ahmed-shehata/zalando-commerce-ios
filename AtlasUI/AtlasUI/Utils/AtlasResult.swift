//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func handleError(checkoutProviderType checkoutProviderType: CheckoutProviderType) -> T? {
        switch self {
        case .failure(let error):
            displayError(error, checkoutProviderType: checkoutProviderType)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType, checkoutProviderType: CheckoutProviderType) {
        checkoutProviderType.userMessage.generalError()
    }
    
}
