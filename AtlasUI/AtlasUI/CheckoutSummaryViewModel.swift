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
    var uiModel: CheckoutSummaryUIModel
}

extension CheckoutSummaryViewModel {

    private func validateAgainstOldDataModel(oldDataModel: CheckoutSummaryDataModel) {
        checkPriceChange(oldDataModel)
        checkPaymentMethod(oldDataModel)
    }

    private func checkPriceChange(oldDataModel: CheckoutSummaryDataModel) {
        guard let
            oldPrice = oldDataModel.totalPrice,
            newPrice = dataModel.totalPrice else { return }

        if oldPrice != newPrice {
            UserMessage.displayError(AtlasCheckoutError.priceChanged(newPrice: newPrice))
        }
    }

    private func checkPaymentMethod(oldDataModel: CheckoutSummaryDataModel) {
        guard oldDataModel.paymentMethod != nil && dataModel.paymentMethod == nil else { return }
        UserMessage.displayError(AtlasCheckoutError.paymentMethodNotAvailable)
    }

}
