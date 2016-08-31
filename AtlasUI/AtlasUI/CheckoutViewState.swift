//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum CheckoutViewState {

    case NotLoggedIn
    case LoggedIn
    case OrderPlaced
    case IncompleteCheckout

    var submitButtonTitleLocalizedKey: String {
        switch self {
        case .NotLoggedIn: return "Zalando.Checkout"
        case .IncompleteCheckout, .LoggedIn: return "order.place"
        case .OrderPlaced: return "navigation.back.shop"
        }
    }

    var submitButtonBackgroundColor: UIColor {
        switch self {
        case .NotLoggedIn, .LoggedIn: return .orangeColor()
        case .IncompleteCheckout: return .grayColor()
        case .OrderPlaced: return UIColor(red: 80.0 / 255.0, green: 150.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
        }
    }

    var navigationBarTitleLocalizedKey: String {
        switch self {
        case .NotLoggedIn, .LoggedIn, .IncompleteCheckout: return "Summary"
        case .OrderPlaced: return "order.placed"
        }
    }

    var showCancelButton: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .IncompleteCheckout: return true
        case .OrderPlaced: return false
        }
    }

    var showPrice: Bool {
        switch self {
        case .LoggedIn, .OrderPlaced, .IncompleteCheckout: return true
        case .NotLoggedIn: return false
        }
    }

    var showFooter: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .IncompleteCheckout: return true
        case .OrderPlaced: return false
        }
    }

    var showDetailArrow: Bool {
        switch self {
        case .NotLoggedIn, .LoggedIn, .IncompleteCheckout: return true
        case .OrderPlaced: return false
        }
    }

    func hideBackButton(hasSingleUnit: Bool) -> Bool {
        guard !hasSingleUnit else { return true }
        switch self {
        case .OrderPlaced: return true
        case .NotLoggedIn, .LoggedIn, .IncompleteCheckout: return false
        }
    }

}
