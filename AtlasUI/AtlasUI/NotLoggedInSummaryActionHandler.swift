//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct NotLoggedInSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmitButton() {
        guard let dataSource = dataSource,
            let delegate = delegate
            else { return }

        AtlasUIClient.customer { result in
            guard let customer = result.process() else { return }
            let selectedArticleUnit = dataSource.dataModel.selectedArticleUnit

            LoggedInSummaryActionHandler.create(customer: customer, selectedArticleUnit: selectedArticleUnit) { result in
                guard let actionHandler = result.process() else { return }

                let dataModel = CheckoutSummaryDataModel(selectedArticleUnit: selectedArticleUnit, cartCheckout: actionHandler.cartCheckout)
                delegate.updated(actionHandler: actionHandler)
                delegate.updated(dataModel: dataModel)
                delegate.updated(layout: LoggedInLayout())
            }
        }
    }

    func presentPaymentSelectionScreen() {
        handleSubmitButton()
    }

    func presentShippingAddressSelectionScreen() {
        handleSubmitButton()
    }

    func presentBillingAddressSelectionScreen() {
        handleSubmitButton()
    }

}
