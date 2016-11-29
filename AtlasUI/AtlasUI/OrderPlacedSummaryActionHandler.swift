//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct OrderPlacedSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmit() {
        delegate?.dismissView()
    }

    func handlePaymentSelection() {
        // Show Payment screen should have no action in Order placed mode
    }

    func handleShippingAddressSelection() {
        // Show Shipping Address screen should have no action in Order placed mode
    }

    func handleBillingAddressSelection() {
        // Show Billing Address screen should have no action in Order placed mode
    }

}
