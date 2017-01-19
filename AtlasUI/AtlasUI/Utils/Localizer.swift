//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct Localizer {

    enum Error: AtlasError {

        case languageNotFound
        case localizedStringsNotFound
        case missingTranslation(key: String, language: String)

    }

    fileprivate let locale: Locale
    fileprivate let fallbackLocale = Locale(identifier: "en_US")

    fileprivate let localizedStringsBundle: Bundle
    fileprivate let localizedStringsFallbackBundle: Bundle

    fileprivate let priceFormatter: NumberFormatter
    fileprivate let dateFormatter: DateFormatter

    init(localeIdentifier: String) throws {
        try self.init(localeIdentifier: localeIdentifier,
                      localizedStringsBundle: Bundle(for: AtlasUI.self))
    }

    init(localeIdentifier: String, localizedStringsBundle: Bundle) throws {
        locale = Locale(identifier: localeIdentifier)

        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = self.locale

        priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = self.locale

        self.localizedStringsBundle = try Bundle.languageBundle(forLanguage: locale, from: localizedStringsBundle)
        self.localizedStringsFallbackBundle = try Bundle.languageBundle(forLanguage: fallbackLocale, from: localizedStringsBundle)
    }

    func countryName(forCountryCode countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }

        return (locale as NSLocale).displayName(forKey: .countryCode, value: countryCode)
    }

    func format(string key: String, formatArguments: [CVarArg?]? = nil) -> String {
        do {
            return try format(string: key, bundle: self.localizedStringsBundle, formatArguments: formatArguments)
        } catch let error {
            if case let Error.missingTranslation(missingKey, language) = error {
                AtlasLogger.logError("Translation not found for '\(missingKey)' language: \(language)")
                if Debug.isEnabled {
                    return key
                }
            }
            return (try? format(string: key, bundle: self.localizedStringsFallbackBundle, formatArguments: formatArguments)) ?? key
        }
    }

    private func format(string key: String, bundle: Bundle, formatArguments: [CVarArg?]? = nil) throws -> String {
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

        if localizedString.length == 0 {
            throw Error.missingTranslation(key: key, language: self.locale.languageCode~?)
        }

        guard let formatArguments = formatArguments, !formatArguments.isEmpty else {
            return localizedString
        }

        return String(format: localizedString, arguments: formatArguments.flatMap { $0 })
    }

    func format(price: NSNumber, withCurrencyCode currencyCode: String? = nil) -> String? {
        priceFormatter.currencyCode = currencyCode
        return priceFormatter.string(from: price)
    }

    func format(date: Date) -> String? {
        return dateFormatter.string(from: date)
    }

}

extension Localizer {

    private static var current: Localizer {
        return try! Localizer(localeIdentifier: Locale.current.identifier) // swiftlint:disable:this force_try
    }

    private static var shared: Localizer {
        return (try? AtlasUI.shared().provide()) ?? Localizer.current
    }

    static func format(string: String, _ formatArguments: [CVarArg?]) -> String {
        return shared.format(string: string, formatArguments: formatArguments.flatMap { $0 })
    }

    static func format(string: String, _ formatArguments: CVarArg?...) -> String {
        return shared.format(string: string, formatArguments: formatArguments)
    }

    static func format(price: NSNumber, withCurrencyCode currencyCode: String? = nil) -> String? {
        return shared.format(price: price, withCurrencyCode: currencyCode)
    }

    static func format(price: Money) -> String? {
        return format(price: price.amount, withCurrencyCode: price.currency)
    }

    static func format(date: Date) -> String? {
        return shared.format(date: date)
    }

    static func countryName(forCountryCode countryCode: String?) -> String? {
        return shared.countryName(forCountryCode: countryCode)
    }

}

extension Bundle {

    fileprivate static func languageBundle(forLanguage locale: Locale, from localizedStringsBundle: Bundle) throws -> Bundle {
        guard let localization = locale.languageCode else {
            throw Localizer.Error.languageNotFound
        }

        let localizedStringsPath = path(from: localizedStringsBundle,
                                        forResourceNamed: "Localizable.strings", forLocalization: localization)
        let localizedStringsFolder = localizedStringsPath?.deletingLastPathComponent

        guard let folder = localizedStringsFolder, let bundle = Bundle(path: folder) else {
            throw Localizer.Error.localizedStringsNotFound
        }

        return bundle
    }

    fileprivate static func path(from bundle: Bundle,
                                 forResourceNamed resourceName: String,
                                 forLocalization localizationName: String) -> NSString? {
        return bundle.path(forResource: resourceName, ofType: nil, inDirectory: nil, forLocalization: localizationName) as NSString?
    }

}
