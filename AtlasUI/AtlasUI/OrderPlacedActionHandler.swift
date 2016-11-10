//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct OrderPlacedActionHandler: CheckoutSummaryActionHandler {

    let uiModel: CheckoutSummaryUIModel = OrderPlacedUIModel()
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmitButton() {
        delegate?.dismissView()
    }

    func showPaymentSelectionScreen() {

    }

    func showShippingAddressSelectionScreen() {

    }

    func showBillingAddressSelectionScreen() {

    }

}
