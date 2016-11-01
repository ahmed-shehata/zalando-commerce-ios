//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum CheckoutViewState {

    case NotLoggedIn
    case CheckoutReady
    case OrderPlaced
    case CheckoutIncomplete

    var submitButtonBackgroundColor: UIColor {
        switch self {
        case .NotLoggedIn, .CheckoutReady: return .orangeColor()
        case .CheckoutIncomplete: return .grayColor()
        case .OrderPlaced: return UIColor(red: 80.0 / 255.0, green: 150.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        }
    }

    var navigationBarTitleLocalizedKey: String {
        switch self {
        case .NotLoggedIn, .CheckoutReady, .CheckoutIncomplete: return "summaryView.title.summary"
        case .OrderPlaced: return "summaryView.title.orderPlaced"
        }
    }

    var showCancelButton: Bool {
        switch self {
        case .NotLoggedIn, .CheckoutReady, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    var showPrice: Bool {
        switch self {
        case .CheckoutReady, .OrderPlaced, .CheckoutIncomplete: return true
        case .NotLoggedIn: return false
        }
    }

    var showFooterLabel: Bool {
        switch self {
        case .NotLoggedIn, .CheckoutReady, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    var showDetailArrow: Bool {
        switch self {
        case .NotLoggedIn, .CheckoutReady, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    func submitButtonTitle(isPaypal: Bool) -> String {
        switch self {
        case .NotLoggedIn: return "summaryView.submitButton.checkoutWithZalando"
        case .CheckoutIncomplete, .CheckoutReady:
            return isPaypal ? "summaryView.submitButton.payWithPapPal" : "summaryView.submitButton.placeOrder"
        case .OrderPlaced: return "summaryView.submitButton.backToShop"
        }
    }

    func hideBackButton(hasSingleUnit: Bool) -> Bool {
        guard !hasSingleUnit else { return true }
        switch self {
        case .OrderPlaced: return true
        case .NotLoggedIn, .CheckoutReady, .CheckoutIncomplete: return false
        }
    }

}
