//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol CheckoutSummaryUIModel {

    var submitButtonBackgroundColor: UIColor { get }
    var navigationBarTitleLocalizedKey: String { get }
    var showCancelButton: Bool { get }
    var showPrice: Bool { get }
    var showFooterLabel: Bool { get }
    var showDetailArrow: Bool { get }
    func submitButtonTitle(isPaypal: Bool) -> String
    func hideBackButton(hasSingleUnit: Bool) -> Bool

}

struct NotLoggedInUIModel: CheckoutSummaryUIModel {

    let submitButtonBackgroundColor: UIColor = .orangeColor()
    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showPrice: Bool = false
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.checkoutWithZalando" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit ? true : false }

}

struct CheckoutIncompleteUIModel: CheckoutSummaryUIModel {

    let submitButtonBackgroundColor: UIColor = .grayColor()
    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showPrice: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    func submitButtonTitle(isPaypal: Bool) -> String { return isPaypal ? "summaryView.submitButton.payWithPapPal" : "summaryView.submitButton.placeOrder" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit ? true : false }

}

struct CheckoutReadyUIModel: CheckoutSummaryUIModel {

    let submitButtonBackgroundColor: UIColor = .orangeColor()
    let navigationBarTitleLocalizedKey: String = "summaryView.title.summary"
    let showCancelButton: Bool = true
    let showPrice: Bool = true
    let showFooterLabel: Bool = true
    let showDetailArrow: Bool = true
    func submitButtonTitle(isPaypal: Bool) -> String { return isPaypal ? "summaryView.submitButton.payWithPapPal" : "summaryView.submitButton.placeOrder" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit ? true : false }

}

struct OrderPlacedUIModel: CheckoutSummaryUIModel {

    let submitButtonBackgroundColor: UIColor = UIColor(red: 80.0 / 255.0, green: 150.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
    let navigationBarTitleLocalizedKey: String = "summaryView.title.orderPlaced"
    let showCancelButton: Bool = false
    let showPrice: Bool = true
    let showFooterLabel: Bool = false
    let showDetailArrow: Bool = false
    func submitButtonTitle(isPaypal: Bool) -> String { return "summaryView.submitButton.backToShop" }
    func hideBackButton(hasSingleUnit: Bool) -> Bool { return hasSingleUnit ? true : true }

}
