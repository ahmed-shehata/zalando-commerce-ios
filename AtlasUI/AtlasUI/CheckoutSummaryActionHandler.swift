//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol CheckoutSummaryActionHandlerDataSource: NSObjectProtocol {

    var dataModel: CheckoutSummaryDataModel { get }

}

protocol CheckoutSummaryActionHandlerDelegate: NSObjectProtocol {

    func dataModelUpdated(dataModel: CheckoutSummaryDataModel)
    func layoutUpdated(layout: CheckoutSummaryLayout)
    func actionHandlerUpdated(actionHandler: CheckoutSummaryActionHandler)
    func dismissView()

}

protocol CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource? { get set }
    weak var delegate: CheckoutSummaryActionHandlerDelegate? { get set }

    func handleSubmitButton()
    func showPaymentSelectionScreen()
    func showShippingAddressSelectionScreen()
    func showBillingAddressSelectionScreen()

}
