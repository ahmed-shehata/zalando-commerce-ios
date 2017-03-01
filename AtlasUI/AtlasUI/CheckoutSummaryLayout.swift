//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

protocol CheckoutSummaryLayout {

    var navigationBarTitleLocalizedKey: String { get }
    var showsCancelButton: Bool { get }
    var showsFooterLabel: Bool { get }
    var showsDetailArrow: Bool { get }
    var showsGuestStackView: Bool { get }
    var showsOrderStackView: Bool { get }
    var showsRecommendationStackView: Bool { get }
    var allowsArticleRefine: Bool { get }

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor
    func submitButtonTitle(isPaypal: Bool) -> String

}

struct ArticleNotSelectedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.selectSize"
    let showsCancelButton = true
    let showsFooterLabel = true
    let showsDetailArrow = true
    let showsGuestStackView = false
    let showsOrderStackView = false
    let showsRecommendationStackView = false
    let allowsArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return .orange }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.title.selectSize" }

}

struct NotLoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showsCancelButton = true
    let showsFooterLabel = true
    let showsDetailArrow = true
    let showsGuestStackView = false
    let showsOrderStackView = false
    let showsRecommendationStackView = false
    let allowsArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return .orange }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }

}

struct LoggedInLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showsCancelButton = true
    let showsFooterLabel = true
    let showsDetailArrow = true
    let showsGuestStackView = false
    let showsOrderStackView = false
    let showsRecommendationStackView = false
    let allowsArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orange : .gray }
    func submitButtonTitle(isPaypal: Bool) -> String {
        return isPaypal ? "summaryView.submitButton.payWithPayPal" : "summaryView.submitButton.placeOrder"
    }

}

struct OrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.orderPlaced"
    let showsCancelButton = false
    let showsFooterLabel = false
    let showsDetailArrow = false
    let showsGuestStackView = false
    let showsOrderStackView = true
    let showsRecommendationStackView = Config.shared?.displayRecommendations ?? true
    let allowsArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }

}

struct GuestCheckoutLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.summary"
    let showsCancelButton = true
    let showsFooterLabel = true
    let showsDetailArrow = true
    let showsGuestStackView = true
    let showsOrderStackView = false
    let showsRecommendationStackView = false
    let allowsArticleRefine = true

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return readyToCheckout ? .orange : .gray }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.guestCheckout" }

}

struct GuestOrderPlacedLayout: CheckoutSummaryLayout {

    let navigationBarTitleLocalizedKey = "summaryView.title.orderPlaced"
    let showsCancelButton = false
    let showsFooterLabel = false
    let showsDetailArrow = false
    let showsGuestStackView = true
    let showsOrderStackView = true
    let showsRecommendationStackView = Config.shared?.displayRecommendations ?? true
    let allowsArticleRefine = false

    func submitButtonBackgroundColor(readyToCheckout: Bool) -> UIColor { return UIColor(hex: 0x509614) }
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }

}
