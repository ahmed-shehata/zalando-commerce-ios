//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum CheckoutViewState {

    case NotLoggedIn
    case LoggedIn
    case OrderPlaced
    case CheckoutIncomplete

    var submitButtonBackgroundColor: UIColor {
        switch self {
        case .NotLoggedIn, .LoggedIn: return .orangeColor()
        case .CheckoutIncomplete: return .grayColor()
        case .OrderPlaced: return UIColor(red: 80.0 / 255.0, green: 150.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        }
    }

    var navigationBarTitleLocalizedKey: String {
        switch self {
        case .NotLoggedIn, .LoggedIn, .CheckoutIncomplete: return "Summary"
        case .OrderPlaced: return "order.placed"
        }
    }

    var showCancelButton: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    var showPrice: Bool {
        switch self {
        case .LoggedIn, .OrderPlaced, .CheckoutIncomplete: return true
        case .NotLoggedIn: return false
        }
    }

    var showFooterLabel: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    var showDetailArrow: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .CheckoutIncomplete: return true
        case .OrderPlaced: return false
        }
    }

    func submitButtonTitle(isPaypal: Bool) -> String {
        switch self {
        case .NotLoggedIn: return "Zalando.Checkout"
        case .CheckoutIncomplete, .LoggedIn:
            return isPaypal ? "order.place.paypal" : "order.place"
        case .OrderPlaced: return "navigation.back.shop"
        }
    }

    func hideBackButton(hasSingleUnit: Bool) -> Bool {
        guard !hasSingleUnit else { return true }
        switch self {
        case .OrderPlaced: return true
        case .NotLoggedIn, .LoggedIn, .CheckoutIncomplete: return false
        }
    }

}
