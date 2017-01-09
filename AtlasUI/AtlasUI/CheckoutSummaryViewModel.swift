//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryViewModel {

    var dataModel: CheckoutSummaryDataModel {
        didSet {
            validate(against: oldValue)
        }
    }
    var layout: CheckoutSummaryLayout

}

extension CheckoutSummaryViewModel {

    fileprivate func validate(against oldDataModel: CheckoutSummaryDataModel) {
        checkPriceChange(comparedTo: oldDataModel)
        checkPaymentAvailable(comparedTo: oldDataModel)
    }

    fileprivate func checkPriceChange(comparedTo oldDataModel: CheckoutSummaryDataModel) {
        if oldDataModel.totalPrice != dataModel.totalPrice {
            UserMessage.displayError(error: AtlasCheckoutError.priceChanged(newPrice: dataModel.totalPrice))
        }
    }

    fileprivate func checkPaymentAvailable(comparedTo oldDataModel: CheckoutSummaryDataModel) {
        if oldDataModel.paymentMethod != nil && dataModel.paymentMethod == nil {
            UserMessage.displayError(error: AtlasCheckoutError.paymentMethodNotAvailable)
        }
    }

}
