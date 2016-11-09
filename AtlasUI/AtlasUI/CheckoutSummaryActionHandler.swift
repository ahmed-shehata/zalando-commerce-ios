//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias CheckoutSummaryDataModelCompletion = AtlasResult<CheckoutSummaryDataModel> -> Void

protocol CheckoutSummaryActionHandler {

    func createCheckoutSummaryDataModel(selectedArticleUnit: SelectedArticleUnit, completion: CheckoutSummaryDataModelCompletion)
    func handleSubmitButton()
    func showPaymentSelectionScreen()
    func showShippingAddressSelectionScreen()
    func showBillingAddressSelectionScreen()

}
