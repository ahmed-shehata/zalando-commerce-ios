//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol Localizer {

    func countryName(forCountryCode countryCode: String?) -> String?
    func string(key: String, formatArguments: [CVarArgType?]?) -> String
    func price(price: NSNumber) -> String?
    func date(date: NSDate) -> String?

}

extension Localizer {

    static var instance: Localizer {
        return (try? Atlas.provide() as Localizer) ?? UILocalizer(localeIdentifier: "en_US", localizedStringsBundle: NSBundle.mainBundle())
    }

    static func string(key: String, _ formatArguments: Any?...) -> String {
        return "" // TODO: return instance.string(key, formatArguments: formatArguments)
    }

    static func price(price: NSNumber) -> String? {
        return instance.price(price)
    }

    static func date(date: NSDate) -> String? {
        return instance.date(date)
    }

    static func countryName(forCountryCode countryCode: String?) -> String? {
        return instance.countryName(forCountryCode: countryCode)
    }

}

struct UILocalizer: Localizer {

    private let locale: NSLocale
    private let priceFormatter: NSNumberFormatter
    private let dateFormatter: NSDateFormatter
    private let localizedStringsBundle: NSBundle

    init(localeIdentifier: String, localizedStringsBundle: NSBundle) {
        self.locale = NSLocale(localeIdentifier: localeIdentifier)
        self.localizedStringsBundle = localizedStringsBundle

        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = self.locale

        priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .CurrencyStyle
        priceFormatter.locale = self.locale
    }

    func countryName(forCountryCode countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }
        return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }

    func string(key: String, formatArguments: [CVarArgType?]?) -> String {
        let localizedString = NSLocalizedString(key, bundle: self.localizedStringsBundle, comment: "")

        guard let formatArguments = formatArguments where !formatArguments.isEmpty else {
            return localizedString
        }

        return String(format: localizedString, arguments: formatArguments.flatMap { $0 })
    }

    func price(price: NSNumber) -> String? {
        return priceFormatter.stringFromNumber(price)
    }

    func date(date: NSDate) -> String? {
        return dateFormatter.stringFromDate(date)
    }

}
