//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol CheckoutSummaryActionHandlerDelegate: NSObjectProtocol {

    var viewModel: CheckoutSummaryViewModel { get set }
    var actionHandler: CheckoutSummaryActionHandler { get set }

    func dismissView()

}

protocol CheckoutSummaryActionHandler {

    var uiModel: CheckoutSummaryUIModel { get }
    weak var delegate: CheckoutSummaryActionHandlerDelegate? { get set }

    mutating func handleSubmitButton()
    mutating func showPaymentSelectionScreen()
    mutating func showShippingAddressSelectionScreen()
    mutating func showBillingAddressSelectionScreen()

}
