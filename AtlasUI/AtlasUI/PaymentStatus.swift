//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

enum PaymentStatus: Equatable {

    case guestRedirect(encryptedCheckoutId: String, encryptedToken: String)
    case redirect
    case success
    case cancel
    case error

    static var statusKey = "payment_status"

    init?(callbackURLComponents: URLComponents, requestURLComponents: URLComponents) {
        guard let callbackHost = callbackURLComponents.host,
            let requestHost = requestURLComponents.host,
            callbackHost.lowercased() == requestHost.lowercased()
            else { return nil }

        self.init(requestURLComponents: requestURLComponents)
    }

}

extension PaymentStatus {

    fileprivate init?(fromString string: String?) {
        guard let string = string else { return nil }

        switch string {
        case "success": self = .success
        case "cancel": self = .cancel
        case "error": self = .error
        default: return nil
        }
    }

    fileprivate init(requestURLComponents: URLComponents) {
        if let paymentStatus = PaymentStatus(fromString: requestURLComponents.paymentStatus) {
            self = paymentStatus
        } else if let guestRedirect = requestURLComponents.guestRedirect {
            self = .guestRedirect(encryptedCheckoutId: guestRedirect.encryptedCheckoutId,
                                  encryptedToken: guestRedirect.encryptedToken)
        } else {
            self = .redirect
        }
    }

}

extension URLComponents {

    fileprivate var paymentStatus: String? {
        return queryItems?.first(where: { $0.name == PaymentStatus.statusKey })?.value
    }

    fileprivate var guestRedirect: (encryptedCheckoutId: String, encryptedToken: String)? {
        guard isGuestRedirect else { return nil }
        return (encryptedCheckoutId: pathComponents[1], encryptedToken: pathComponents[2])
    }

    private var isGuestRedirect: Bool {
        guard let action = pathComponents.first, action == "redirect" else { return false }
        return pathComponents.count == 3
    }

    private var pathComponents: [String] {
        return path.components(separatedBy: "/").filter({ !$0.isEmpty })
    }

}

func == (lhs: PaymentStatus, rhs: PaymentStatus) -> Bool {
    switch (lhs, rhs) {
    case (.guestRedirect(let lhsCheckoutId, let lhsToken), .guestRedirect(let rhsCheckoutId, let rhsToken)):
        return lhsCheckoutId == rhsCheckoutId && lhsToken == rhsToken
    case (.redirect, .redirect): return true
    case (.success, .success): return true
    case (.cancel, .cancel): return true
    case (.error, .error): return true
    default: return false
    }
}
