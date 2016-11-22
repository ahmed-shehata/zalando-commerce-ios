//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct Localizer {

    enum Error: AtlasErrorType {

        case languageNotFound
        case localizedStringsNotFound

    }

    fileprivate let locale: Locale
    fileprivate let priceFormatter: NumberFormatter
    fileprivate let dateFormatter: DateFormatter
    fileprivate let localizedStringsBundle: Bundle

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
    }

    func countryName(forCountryCode countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }
        return (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
    }

    func string(_ key: String, formatArguments: [CVarArg?]? = nil) -> String {
        let localizedString = NSLocalizedString(key, bundle: self.localizedStringsBundle, comment: "")

        guard let formatArguments = formatArguments, !formatArguments.isEmpty else {
            return localizedString
        }

        return String(format: localizedString, arguments: formatArguments.flatMap { $0 })
    }

    func price(_ price: NSNumber) -> String? {
        return priceFormatter.string(from: price)
    }

    func date(_ date: Date) -> String? {
        return dateFormatter.string(from: date)
    }

}

extension Localizer {

    fileprivate static var shared: Localizer {
        do {
            return try AtlasUI.provide() as Localizer
        } catch {
            return try! Localizer(localeIdentifier: Locale.current.identifier) // swiftlint:disable:this force_try
        }
    }

    static func string(_ key: String, _ formatArguments: [CVarArg?]) -> String {
        return shared.string(key, formatArguments: formatArguments.flatMap { $0 })
    }

    static func string(_ key: String, _ formatArguments: CVarArg?...) -> String {
        return shared.string(key, formatArguments: formatArguments)
    }

    static func price(_ price: NSNumber) -> String? {
        return shared.price(price)
    }

    static func date(_ date: Date) -> String? {
        return shared.date(date)
    }

    static func countryName(forCountryCode countryCode: String?) -> String? {
        return shared.countryName(forCountryCode: countryCode)
    }

}

extension Bundle {

    fileprivate static func languageBundle(forLanguage locale: Locale, from localizedStringsBundle: Bundle) throws -> Bundle {
        guard let localization = (locale as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String else {
            throw Localizer.Error.languageNotFound
        }

        let localizedStringsPath = path(from: localizedStringsBundle,
                                        forResourceNamed: "Localizable.strings", forLocalization: localization)
        let localizedStringsFolder = localizedStringsPath?.deletingLastPathComponent

        guard let folder = localizedStringsFolder,
            let bundle = Bundle(path: folder)
            else {
            throw Localizer.Error.localizedStringsNotFound
        }

        return bundle
    }

    fileprivate static func path(from bundle: Bundle, forResourceNamed resourceName: String,
                                 forLocalization localizationName: String) -> NSString? {
        return bundle.path(forResource: resourceName, ofType: nil, inDirectory: nil, forLocalization: localizationName) as NSString?
    }

}
