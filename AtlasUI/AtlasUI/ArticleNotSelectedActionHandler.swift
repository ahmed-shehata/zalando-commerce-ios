//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct ArticleNotSelectedActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmit() {
        // Submit Button should have no action if the article is not selected
    }

    func handlePaymentSelection() {
        // Show Payment screen should have no action if the article is not selected
    }

    func handleShippingAddressSelection() {
        // Show Shipping Address screen should have no action if the article is not selected
    }

    func handleBillingAddressSelection() {
        // Show Billing Address screen should have no action if the article is not selected
    }

    fileprivate func presentCheckoutScreen(selectedArticle: SelectedArticle) {
//        guard AtlasAPIClient.shared?.isAuthorized == true else {
//            let actionHandler = NotLoggedInSummaryActionHandler()
//            let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle,
//                                                     totalPrice: selectedArticle.totalPrice)
//            let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: NotLoggedInLayout())
//            return presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
//        }
//
//        AtlasUIClient.customer { [weak self] customerResult in
//            guard let customer = customerResult.process() else { return }
//
//            LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { actionHandlerResult in
//                guard let actionHandler = actionHandlerResult.process() else { return }
//
//                let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
//                let viewModel = CheckoutSummaryViewModel(dataModel: dataModel, layout: LoggedInLayout())
//                self?.presentCheckoutSummaryViewController(viewModel: viewModel, actionHandler: actionHandler)
//            }
//        }
    }

    fileprivate func presentCheckoutSummaryViewController(viewModel: CheckoutSummaryViewModel,
                                                          actionHandler: CheckoutSummaryActionHandler) {
//        let checkoutSummaryVC = CheckoutSummaryViewController(viewModel: viewModel)
//        checkoutSummaryVC.actionHandler = actionHandler
//        navigationController?.pushViewController(checkoutSummaryVC, animated: true)
    }

}
