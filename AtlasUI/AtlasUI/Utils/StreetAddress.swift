//
//  StreetAddress.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 15/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension StreetAddress {

    internal func prefixedAddressLine1(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !addressLine1.isEmpty else { return addressLine1 }
        return localizer.loc("Address.prefix.packstation") + ": " + addressLine1
    }

    internal func prefixedAddressLine2(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !addressLine2.isEmpty else { return addressLine2 }
        return localizer.loc("Address.prefix.memberID") + ": " + addressLine2
    }

    internal func prefixedShortAddressLine(localizedWith localizer: LocalizerProviderType) -> String {
        guard isPickupPoint && !shortAddressLine.isEmpty else { return shortAddressLine }
        return localizer.loc("Address.prefix.packstation.abbreviation") + ": " + shortAddressLine
    }

}
