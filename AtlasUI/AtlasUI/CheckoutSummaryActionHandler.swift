//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol CheckoutSummaryActionHandlerDataSource: NSObjectProtocol {

    var dataModel: CheckoutSummaryDataModel { get }

}

protocol CheckoutSummaryActionHandlerDelegate: NSObjectProtocol {

    func updated(dataModel: CheckoutSummaryDataModel)
    func updated(layout: CheckoutSummaryLayout)
    func updated(actionHandler: CheckoutSummaryActionHandler)
    func dismissView()

}

protocol CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource? { get set }
    weak var delegate: CheckoutSummaryActionHandlerDelegate? { get set }

    func handleSubmit()
    func handlePaymentSelection()
    func handleShippingAddressSelection()
    func handleBillingAddressSelection()

}
