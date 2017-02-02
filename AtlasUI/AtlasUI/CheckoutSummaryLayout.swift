//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

protocol CheckoutSummaryLayout {

    var navigationBarTitleLocalizedKey: String { get }
    var showCancelButton: Bool { get }
    var showFooterLabel: Bool { get }
    var showDetailArrow: Bool { get }
    var showGuestStackView: Bool { get }
    var showOrderStackView: Bool { get }
    var allowArticleRefine: Bool { get }

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor
    func submitButtonTitle(isPaypal: Bool) -> String

}

struct ArticleNotSelectedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.selectSize"
    let showCancelButton = true
    let showFooterLabel = true
    let showDetailArrow = true
    let showGuestStackView = false
    let showOrderStackView = false
    let allowArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return .orange }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.title.selectSize" }

}

struct NotLoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showCancelButton = true
    let showFooterLabel = true
    let showDetailArrow = true
    let showGuestStackView = false
    let showOrderStackView = false
    let allowArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return .orange }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }

}

struct LoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showCancelButton = true
    let showFooterLabel = true
    let showDetailArrow = true
    let showGuestStackView = false
    let showOrderStackView = false
    let allowArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orange : .gray }
    func submitButtonTitle(isPaypal: Bool) -> String {
        return isPaypal ? "summaryView.submitButton.payWithPayPal" : "summaryView.submitButton.placeOrder"
    }

}

struct OrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.orderPlaced"
    let showCancelButton = false
    let showFooterLabel = false
    let showDetailArrow = false
    let showGuestStackView = false
    let showOrderStackView = true
    let allowArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }

}

struct GuestCheckoutLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showCancelButton = true
    let showFooterLabel = true
    let showDetailArrow = true
    let showGuestStackView = true
    let showOrderStackView = false
    let allowArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orange : .gray }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.guestCheckout" }

}

struct GuestOrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.orderPlaced"
    let showCancelButton = false
    let showFooterLabel = false
    let showDetailArrow = false
    let showGuestStackView = true
    let showOrderStackView = true
    let allowArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }

}
