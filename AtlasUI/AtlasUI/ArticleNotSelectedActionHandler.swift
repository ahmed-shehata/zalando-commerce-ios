//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class ArticleNotSelectedActionHandler: CheckoutSummaryActionHandler {

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

    func updated(selectedArticle: SelectedArticle) {
        guard AtlasAPIClient.shared?.isAuthorized == true else {
            let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, totalPrice: selectedArticle.totalPrice)
            try? delegate?.updated(dataModel: dataModel)
            delegate?.updated(layout: NotLoggedInLayout())
            delegate?.updated(actionHandler: NotLoggedInSummaryActionHandler())
            return
        }

        AtlasUIClient.customer { [weak self] customerResult in
            guard let customer = customerResult.process() else { return }

            LoggedInSummaryActionHandler.create(customer: customer, selectedArticle: selectedArticle) { actionHandlerResult in
                guard let actionHandler = actionHandlerResult.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticle: selectedArticle, cartCheckout: actionHandler.cartCheckout)
                try? self?.delegate?.updated(dataModel: dataModel)
                self?.delegate?.updated(layout: LoggedInLayout())
                self?.delegate?.updated(actionHandler: actionHandler)
            }
        }
    }

}
