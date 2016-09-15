//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol Localizable {

    var localeIdentifier: String { get }
    var localizedStringsBundle: NSBundle { get }

}

struct Localizer {

    let locale: NSLocale
    let localizationProvider: Localizable

    private let priceFormatter: NSNumberFormatter
    private let dateFormatter: NSDateFormatter
    private var localizedStringsBundle: NSBundle!

    init(localizationProvider: Localizable, defaultLocalization: String = "en") {
        self.localizationProvider = localizationProvider
        self.locale = NSLocale(localeIdentifier: localizationProvider.localeIdentifier)

        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.locale = self.locale

        priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .CurrencyStyle
        priceFormatter.locale = self.locale

        self.localizedStringsBundle = findLocalizedStringsBundle(defaultLocalization)
    }

    func localizedString(key: String, formatArguments: [CVarArgType?]? = nil) -> String {
        let localizedString = NSLocalizedString(key, bundle: self.localizedStringsBundle, comment: "")

        guard let formatArguments = formatArguments where !formatArguments.isEmpty else {
            return localizedString
        }

        return String(format: localizedString, arguments: formatArguments.flatMap { $0 })
    }

    func countryName(forCountryCode countryCode: String?) -> String? {
        guard let countryCode = countryCode else { return nil }
        return locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
    }

    func fmtPrice(number: NSNumber) -> String? {
        return priceFormatter.stringFromNumber(number)
    }

    func fmtDate(date: NSDate) -> String? {
        return dateFormatter.stringFromDate(date)
    }

    private func findLocalizedStringsBundle(defaultLocalization: String) -> NSBundle {
        let localizationKeys = [NSLocaleIdentifier, NSLocaleLanguageCode, defaultLocalization]

        for key in localizationKeys {
            guard let localization = locale.objectForKey(key) as? String else { continue }
            let localizedStringsPath = path(forResourceNamed: "Localizable.strings", forLocalization: localization)
            let localizedStringsFolder = localizedStringsPath?.stringByDeletingLastPathComponent
            if let folder = localizedStringsFolder, bundle = NSBundle(path: folder) {
                return bundle
            }
        }

        return localizationProvider.localizedStringsBundle
    }

    private func path(forResourceNamed resourceName: String, forLocalization localizationName: String) -> NSString? {
        return localizationProvider.localizedStringsBundle.pathForResource(resourceName,
            ofType: nil, inDirectory: nil, forLocalization: localizationName) as NSString?
    }

}
