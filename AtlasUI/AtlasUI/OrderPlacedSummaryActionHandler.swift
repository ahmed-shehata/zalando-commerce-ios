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

    func presentPaymentSelectionScreen() {
        // Show Payment screen should have no action in Order placed mode
    }

    func presentShippingAddressSelectionScreen() {
        // Show Shipping Address screen should have no action in Order placed mode
    }

    func presentBillingAddressSelectionScreen() {
        // Show Billing Address screen should have no action in Order placed mode
    }

}
