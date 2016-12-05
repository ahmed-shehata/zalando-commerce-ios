//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol CheckoutSummaryLayout {

    var navigationBarTitleLocalizedKey: String { get }
    var showCancelButton: Bool { get }
    var showFooterLabel: Bool { get }
    var showDetailArrow: Bool { get }
    var showGuestStackView: Bool { get }

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor
    func submitButtonTitle(isPaypal: Bool) -> String
    func hideBackButton(hasSingleUnit: Bool) -> Bool

}

struct NotLoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    let showGuestStackView: Bool = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return .orange }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit }

}

struct GuestCheckoutLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    let showGuestStackView: Bool = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orangeColor() : .grayColor() }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit }

}

struct LoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    let showGuestStackView: Bool = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orange : .gray }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton." + (isPaypal ? "payWithPapPal" : "placeOrder") }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit }

}

struct OrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.orderPlaced"
    let showCancelButton: Bool = false
    let showFooterLabel: Bool = false
    let showDetailArrow: Bool = false
    let showGuestStackView: Bool = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return true }

}

struct GuestOrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey: String = "summaryView.title.orderPlaced"
    let showCancelButton: Bool = false
    let showFooterLabel: Bool = false
    let showDetailArrow: Bool = false
    let showGuestStackView: Bool = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return true }

}
