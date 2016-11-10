//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias LoggedInActionHandlerCompletion = AtlasResult<LoggedInActionHandler> -> Void
typealias CartCheckout = (cart: Cart?, checkout: Checkout?)
typealias CreateCartCheckoutCompletion = AtlasResult<CartCheckout> -> Void

struct LoggedInActionHandler: CheckoutSummaryActionHandler {

    let customer: Customer
    var cart: Cart?
    var checkout: Checkout?
    let uiModel: CheckoutSummaryUIModel = LoggedInUIModel()
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    static func createInstance(customer: Customer, selectedArticleUnit: SelectedArticleUnit, completion: LoggedInActionHandlerCompletion) {
        var actionHandler = LoggedInActionHandler(customer: customer, cart: nil, checkout: nil, delegate: nil)
        actionHandler.createCheckout(selectedArticleUnit) { result in
            switch result {
            case .success(let cartCheckout):
                actionHandler.cart = cartCheckout.cart
                actionHandler.checkout = cartCheckout.checkout
                completion(.success(actionHandler))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    mutating func handleSubmitButton() {
        guard let delegate = delegate else { return }
        guard delegate.viewModel.dataModel.isPaymentSelected else {
            UserMessage.displayError(AtlasCheckoutError.missingAddressAndPayment)
            return
        }

        let selectedUnit = delegate.viewModel.dataModel.selectedArticleUnit
        createCheckout(selectedUnit) { result in
            guard let
                cartCheckout = result.process(),
                cart = cartCheckout.cart,
                checkout = cartCheckout.checkout else { return }

            self.cart = cart
            self.checkout = checkout

            if delegate.viewModel.dataModel.isPaymentSelected && !UserMessage.errorDisplayed {
                AtlasAPIClient.createOrder(checkout.id) { result in
                    guard let order = result.process() else { return }

                    let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedUnit, checkout: checkout, order: order)
                    delegate.actionHandler = OrderPlacedActionHandler()
                    delegate.viewModel.dataModel = dataModel
                }
            }
        }

    }

    func showPaymentSelectionScreen() {

    }

    func showShippingAddressSelectionScreen() {

    }

    func showBillingAddressSelectionScreen() {

    }

}

extension LoggedInActionHandler {

    private func createCheckout(selectedArticleUnit: SelectedArticleUnit, completion: CreateCartCheckoutCompletion) {
        let addresses = delegate?.viewModel.dataModel.addresses
        AtlasAPIClient.createCheckoutCart(selectedArticleUnit.sku, addresses: addresses) { result in
            switch result {
            case .failure(let error):
                if case let AtlasAPIError.checkoutFailed(cart, _) = error {
                    completion(.success((cart: cart, checkout: nil)))
                    if addresses?.billingAddress != nil && addresses?.shippingAddress != nil {
                        UserMessage.displayError(AtlasCheckoutError.checkoutFailure)
                    }
                } else {
                    completion(.failure(error))
                }
            case .success(let checkoutCart):
                completion(.success((cart: checkoutCart.cart, checkout: checkoutCart.checkout)))
            }
        }
    }

}
