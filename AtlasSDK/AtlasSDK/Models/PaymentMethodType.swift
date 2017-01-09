//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

// swiftlint:disable cyclomatic_complexity

public enum PaymentMethodType {

    case applePay
    case cashOnDelivery
    case cheque
    case creditCard
    case directDebit
    case electronicPaymentStandard
    case free
    case ideal
    case invoice
    case maksuturva
    case payPal
    case postFinance
    case prepayment
    case przelewy24
    case trustly
    case unknown
    case unrecognized(rawValue: String)

    public init(rawValue: String) {
        switch rawValue {
        case "APPLE_PAY": self = .applePay
        case "CASH_ON_DELIVERY": self = .cashOnDelivery
        case "CHEQUE": self = .cheque
        case "CREDIT_CARD": self = .creditCard
        case "DIRECT_DEBIT": self = .directDebit
        case "ELECTRONIC_PAYMENT_STANDARD": self = .electronicPaymentStandard
        case "FREE": self = .free
        case "IDEAL": self = .ideal
        case "INVOICE": self = .invoice
        case "MAKSUTURVA": self = .maksuturva
        case "PAYPAL": self = .payPal
        case "POSTFINANCE": self = .postFinance
        case "PREPAYMENT": self = .prepayment
        case "PRZELEWY24": self = .przelewy24
        case "TRUSTLY": self = .trustly
        case "UNKNOWN": self = .unknown
        default: self = .unrecognized(rawValue: rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .applePay: return "APPLE_PAY"
        case .cashOnDelivery: return "CASH_ON_DELIVERY"
        case .cheque: return "CHEQUE"
        case .creditCard: return "CREDIT_CARD"
        case .directDebit: return "DIRECT_DEBIT"
        case .electronicPaymentStandard: return "ELECTRONIC_PAYMENT_STANDARD"
        case .free: return "FREE"
        case .ideal: return "IDEAL"
        case .invoice: return "INVOICE"
        case .maksuturva: return "MAKSUTURVA"
        case .payPal: return "PAYPAL"
        case .postFinance: return "POSTFINANCE"
        case .prepayment: return "PREPAYMENT"
        case .przelewy24: return "PRZELEWY24"
        case .trustly: return "TRUSTLY"
        case .unknown: return "UNKNOWN"
        case .unrecognized(let rawValue): return rawValue
        }
    }

}
