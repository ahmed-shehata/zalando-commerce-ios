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

    private func validateAgainstOldDataModel(oldDataModel: CheckoutSummaryDataModel) {
        checkPriceChange(oldDataModel)
        checkPaymentMethod(oldDataModel)
    }

    private func checkPriceChange(oldDataModel: CheckoutSummaryDataModel) {
        if oldDataModel.totalPrice != dataModel.totalPrice {
            UserMessage.displayError(AtlasCheckoutError.priceChanged(newPrice: dataModel.totalPrice))
        }
    }

    private func checkPaymentMethod(oldDataModel: CheckoutSummaryDataModel) {
        guard oldDataModel.paymentMethod != nil && dataModel.paymentMethod == nil else { return }
        UserMessage.displayError(AtlasCheckoutError.paymentMethodNotAvailable)
    }

}
