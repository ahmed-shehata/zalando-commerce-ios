//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public protocol AtlasError: Error {

    var localizedTitleKey: String { get }
    var localizedMessageKey: String { get }

}

public extension AtlasError {

    var localizedTitleKey: String { return "\(type(of: self)).title.\(self)" }
    var localizedMessageKey: String { return "\(type(of: self)).message.\(self)" }

}

public enum AtlasConfigurationError: AtlasError {

    case incorrectConfigServiceResponse
    case missingClientId
    case missingSalesChannel

}

public enum AtlasAPIError: AtlasError {

    case noData
    case noInternet
    case invalidResponseFormat
    case unauthorized

    case nsURLError(code: Int, details: String?)
    case http(status: Int, details: String?)
    case backend(status: Int?, type: String?, title: String?, details: String?)

    case checkoutFailed(cart: Cart?, error: Error)

}

public enum AtlasCheckoutError: AtlasError {

    case unclassified
    case outOfStock
    case missingAddress
    case missingAddressAndPayment
    case unsupportedCountry
    case priceChanged(newPrice: Money)
    case paymentMethodNotAvailable
    case checkoutFailure
    case addressInvalid
    case photosLibraryAccessNotAllowed

}
