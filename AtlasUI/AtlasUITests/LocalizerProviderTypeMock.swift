//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

@testable import AtlasUI

internal class LocalizerProviderTypeMock: LocalizerProviderType {

    lazy var localizer: Localizer = {
        return Localizer(localizationProvider: UnitedKindom())
    }()

}

private struct UnitedKindom: Localizable {
    let localeIdentifier: String = "en_UK"
    let localizedStringsBundle: NSBundle = NSBundle(forClass: CheckoutSummaryViewController.self)
}
