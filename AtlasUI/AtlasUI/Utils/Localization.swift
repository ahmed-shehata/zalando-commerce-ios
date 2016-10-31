//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum AtlasLocalizerError: AtlasErrorType {

    case languageNotFound
    case localizedStringsNotFound

}

struct Localizer {

    private let locale: NSLocale
    private let priceFormatter: NSNumberFormatter
    private let dateFormatter: NSDateFormatter
    private let localizedStringsBundle: NSBundle

    init(localeIdentifier: String) throws {
        try self.init(localeIdentifier: localeIdentifier,
            localizedStringsBundle: NSBundle(forClass: AtlasCheckout.self))
    }

    init(localeIdentifier: String, localizedStringsBundle: NSBundle) throws {
        locale = NSLocale(localeIdentifier: localeIdentifier)

        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = self.locale

        priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .CurrencyStyle
        priceFormatter.locale = self.locale

        self.localizedStringsBundle = try NSBundle.languageBundle(forLanguage: locale, from: localizedStringsBundle)
    }

    func countryName(forCountryCode countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }
        return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }

    func string(key: String, formatArguments: [CVarArgType?]? = nil) -> String {
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

extension Localizer {

    private static var instance: Localizer {
        do {
            return try Atlas.provide() as Localizer
        } catch {
            return try! Localizer(localeIdentifier: NSLocale.currentLocale().localeIdentifier) // swiftlint:disable:this force_try
        }
    }

    static func string(key: String, _ formatArguments: [CVarArgType?]) -> String {
        return instance.string(key, formatArguments: formatArguments.flatMap { $0 })
    }

    static func string(key: String, _ formatArguments: CVarArgType?...) -> String {
        return instance.string(key, formatArguments: formatArguments)
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

extension NSBundle {

    private static func languageBundle(forLanguage locale: NSLocale, from localizedStringsBundle: NSBundle) throws -> NSBundle {
        guard let localization = locale.objectForKey(NSLocaleLanguageCode) as? String else {
            throw AtlasLocalizerError.languageNotFound
        }

        let localizedStringsPath = path(from: localizedStringsBundle,
            forResourceNamed: "Localizable.strings", forLocalization: localization)
        let localizedStringsFolder = localizedStringsPath?.stringByDeletingLastPathComponent

        guard let folder = localizedStringsFolder, bundle = NSBundle(path: folder) else {
            throw AtlasLocalizerError.localizedStringsNotFound
        }

        return bundle
    }

    private static func path(from bundle: NSBundle, forResourceNamed resourceName: String,
        forLocalization localizationName: String) -> NSString? {
            return bundle.pathForResource(resourceName, ofType: nil, inDirectory: nil, forLocalization: localizationName) as NSString?
    }

}
