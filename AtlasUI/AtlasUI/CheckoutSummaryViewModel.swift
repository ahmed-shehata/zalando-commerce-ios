//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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
    fileprivate(set) var errorDisplayedWithLatestDataModel: Bool = false

    init(dataModel: CheckoutSummaryDataModel, layout: CheckoutSummaryLayout) {
        self.dataModel = dataModel
        self.layout = layout
    }

}

extension CheckoutSummaryViewModel {

    fileprivate mutating func validate(against oldDataModel: CheckoutSummaryDataModel) {
        errorDisplayedWithLatestDataModel = false
        checkPriceChange(comparedTo: oldDataModel)
        checkPaymentAvailable(comparedTo: oldDataModel)
    }

    fileprivate mutating func checkPriceChange(comparedTo oldDataModel: CheckoutSummaryDataModel) {
        if oldDataModel.totalPrice != dataModel.totalPrice {
            errorDisplayedWithLatestDataModel = true
            UserMessage.displayError(error: AtlasCheckoutError.priceChanged(newPrice: dataModel.totalPrice))
        }
    }

    fileprivate mutating func checkPaymentAvailable(comparedTo oldDataModel: CheckoutSummaryDataModel) {
        if oldDataModel.paymentMethod != nil && dataModel.paymentMethod == nil {
            errorDisplayedWithLatestDataModel = true
            UserMessage.displayError(error: AtlasCheckoutError.paymentMethodNotAvailable)
        }
    }

}
