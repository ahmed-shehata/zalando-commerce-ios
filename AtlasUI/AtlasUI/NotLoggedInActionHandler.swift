//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct NotLoggedInActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmitButton() {
        guard let dataSource = dataSource, delegate = delegate else { return }

        AtlasUIClient.customer { result in
            guard let customer = result.process() else { return }

            let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit
            LoggedInActionHandler.createInstance(customer, selectedArticleUnit: selectedArticleUnit) { result in
                guard let actionHandler = result.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: actionHandler.cartCheckout)
                delegate.actionHandlerUpdated(actionHandler)
                delegate.dataModelUpdated(dataModel)
                delegate.layoutUpdated(LoggedInLayout())
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
