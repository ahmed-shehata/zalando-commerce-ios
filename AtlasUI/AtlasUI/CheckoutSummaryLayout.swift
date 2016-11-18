//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol CheckoutSummaryLayout {

    var navigationBarTitleLocalizedKey: String { get }
    var showCancelButton: Bool { get }
    var showPrice: Bool { get }
    var showFooterLabel: Bool { get }
    var showDetailArrow: Bool { get }

    func submitButtonBackgroundColor(readyToCheckout readyToCheckout: Bool) -> UIColor
    func submitButtonTitle(isPaypal isPaypal: Bool) -> String
    func hideBackButton(hasSingleUnit hasSingleUnit: Bool) -> Bool

}

struct NotLoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showPrice: Bool = false
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true

    func submitButtonBackgroundColor(readyToCheckout readyToCheckout: Bool) -> UIColor { return .orangeColor() }
    func submitButtonTitle(isPaypal isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }
    func hideBackButton(hasSingleUnit hasSingleUnit: Bool) -> Bool { return hasSingleUnit }

}

struct LoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showPrice: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true

    func submitButtonBackgroundColor(readyToCheckout readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orangeColor() : .grayColor() }
    func submitButtonTitle(isPaypal isPaypal: Bool) -> String { return isPaypal ? "summaryView.submitButton.payWithPapPal" : "summaryView.submitButton.placeOrder" }
    func hideBackButton(hasSingleUnit hasSingleUnit: Bool) -> Bool { return hasSingleUnit }

}

struct OrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.orderPlaced"
    let showCancelButton: Bool = false
    let showPrice: Bool = true
    let showFooterLabel: Bool = false
    let showDetailArrow: Bool = false

    func submitButtonBackgroundColor(readyToCheckout readyToCheckout: Bool) -> UIColor { return UIColor(red: 80.0 / 255.0, green: 150.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0) }
    func submitButtonTitle(isPaypal isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }
    func hideBackButton(hasSingleUnit hasSingleUnit: Bool) -> Bool { return true }

}
