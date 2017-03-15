//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public protocol LocalizableError: Error {

    var localizedTitleKey: String { get }
    var localizedMessageKey: String { get }

}

public extension LocalizableError {

    var localizedTitleKey: String { return "\(type(of: self)).title.\(self)" }
    var localizedMessageKey: String { return "\(type(of: self)).message.\(self)" }

}

public enum ConfigurationError: LocalizableError {

    case incorrectConfigServiceResponse
    case missingClientId
    case missingSalesChannel

}

public enum APIError: LocalizableError {

    case noData
    case noInternet
    case invalidResponseFormat
    case unauthorized

    case nsURLError(code: Int, details: String?)
    case http(status: Int, details: String?)
    case backend(status: Int?, type: String?, title: String?, details: String?)

    case checkoutFailed(error: Error)

}

public enum CheckoutError: LocalizableError {

    case unclassified
    case outOfStock
    case missingAddress
    case missingPaymentMethod
    case unsupportedCountry
    case priceChanged(newPrice: Money)
    case paymentMethodNotAvailable
    case checkoutFailure
    case addressInvalid
    case photosLibraryAccessNotAllowed

}
