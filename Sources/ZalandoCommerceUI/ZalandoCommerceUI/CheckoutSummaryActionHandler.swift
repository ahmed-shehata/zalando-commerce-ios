//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

protocol CheckoutSummaryActionHandlerDataSource: class {

    var dataModel: CheckoutSummaryDataModel { get }

}

protocol CheckoutSummaryActionHandlerDelegate: class {

    func updated(dataModel: CheckoutSummaryDataModel) throws
    func updated(layout: CheckoutSummaryLayout)
    func updated(actionHandler: CheckoutSummaryActionHandler)

}

protocol CheckoutSummaryActionHandler: CheckoutSummaryEditProductDelegate {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource? { get set }
    weak var delegate: CheckoutSummaryActionHandlerDelegate? { get set }

    func handleSubmit()
    func handlePaymentSelection()
    func handleShippingAddressSelection()
    func handleBillingAddressSelection()

}

extension CheckoutSummaryActionHandler {

    var shippingAddress: EquatableAddress? {
        return dataSource?.dataModel.shippingAddress as? EquatableAddress
    }

    var billingAddress: EquatableAddress? {
        return dataSource?.dataModel.billingAddress as? EquatableAddress
    }

    var addresses: CheckoutAddresses? {
        return CheckoutAddresses(shippingAddress: shippingAddress, billingAddress: billingAddress)
    }

    var hasAddresses: Bool {
        return shippingAddress != nil && billingAddress != nil
    }

}
