//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct OrderPlacedSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmitButton() {
        delegate?.dismissView()
    }

    func showPaymentSelectionScreen() {
        // Show Payment screen should have no action in Order placed mode
    }

    func showShippingAddressSelectionScreen() {
        // Show Shipping Address screen should have no action in Order placed mode
    }

    func showBillingAddressSelectionScreen() {
        // Show Billing Address screen should have no action in Order placed mode
    }

}
