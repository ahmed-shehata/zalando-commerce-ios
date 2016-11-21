//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryViewModel {

    var dataModel: CheckoutSummaryDataModel {
        didSet {
            validateAgainstOldDataModel(oldValue)
        }
    }
    var layout: CheckoutSummaryLayout

}

extension CheckoutSummaryViewModel {

    fileprivate func validateAgainstOldDataModel(_ oldDataModel: CheckoutSummaryDataModel) {
        checkPriceChange(oldDataModel)
        checkPaymentMethod(oldDataModel)
    }

    fileprivate func checkPriceChange(_ oldDataModel: CheckoutSummaryDataModel) {
        guard let
            oldPrice = oldDataModel.totalPrice,
            let newPrice = dataModel.totalPrice else { return }

        if oldPrice != newPrice {
            UserMessage.displayError(AtlasCheckoutError.priceChanged(newPrice: newPrice))
        }
    }

    fileprivate func checkPaymentMethod(_ oldDataModel: CheckoutSummaryDataModel) {
        guard oldDataModel.paymentMethod != nil && dataModel.paymentMethod == nil else { return }
        UserMessage.displayError(AtlasCheckoutError.paymentMethodNotAvailable)
    }

}
