//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct NotLoggedInActionHandler: CheckoutSummaryActionHandler {

    let uiModel: CheckoutSummaryUIModel = NotLoggedInUIModel()
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmitButton() {
        guard let delegate = delegate else { return }

        AtlasAPIClient.customer { result in
            guard let customer = result.process() else { return }

            let selectedArticleUnit = delegate.viewModel.dataModel.selectedArticleUnit
            LoggedInActionHandler.createInstance(customer, selectedArticleUnit: selectedArticleUnit) { result in
                guard let actionHandler = result.process() else { return }

                let cart = actionHandler.cart
                let checkout = actionHandler.checkout
                let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cart: cart, checkout: checkout)
                delegate.actionHandler = actionHandler
                delegate.viewModel.dataModel = dataModel
            }
        }
    }

    func showPaymentSelectionScreen() {
        handleSubmitButton()
    }

    func showShippingAddressSelectionScreen() {
        handleSubmitButton()
    }

    func showBillingAddressSelectionScreen() {
        handleSubmitButton()
    }

}
