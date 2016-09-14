//
//  EditAddressViewModel.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 08/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EditAddressViewModel {

    var id: String?
    var gender: Gender?
    var firstName: String?
    var lastName: String?
    var street: String?
    var additional: String?
    var zip: String?
    var city: String?
    var countryCode: String?
    var pickupPointName: String?
    var pickupPointMemberId: String?
    var isDefaultBilling: Bool = false
    var isDefaultShipping: Bool = false

    init (userAddress: EquatableAddress?) {
        guard let userAddress = userAddress else { configureCountryCode(); return }
        id = userAddress.id
        gender = userAddress.gender
        firstName = userAddress.firstName
        lastName = userAddress.lastName
        street = userAddress.street
        additional = userAddress.additional
        zip = userAddress.zip
        city = userAddress.city
        countryCode = userAddress.countryCode
        pickupPointName = userAddress.pickupPoint?.name
        pickupPointMemberId = userAddress.pickupPoint?.memberId
    }

    private func configureCountryCode() {
        // TODO: Need to move to DEMO
        // TODO: Need to use a predefined sales channels for testing until we know the relation between the sales channel and the country
        countryCode = "DE"
    }

    internal func titles(localizer: LocalizerProviderType) -> [String] {
        return [Gender.male.title(localizer), Gender.female.title(localizer)]
    }

    internal func updateTitle(localizedGenderText: String?, localizer: LocalizerProviderType) {
        switch localizedGenderText {
        case Gender.male.title(localizer)?: gender = .male
        case Gender.female.title(localizer)?: gender = .female
        default: gender = nil
        }
    }

    internal func localizedTitle(localizer: LocalizerProviderType) -> String? {
        return gender?.title(localizer)
    }

}

extension Gender {

    private func title(localizer: LocalizerProviderType) -> String {
        switch self {
        case .male: return localizer.loc("Address.edit.gender.male")
        case .female: return localizer.loc("Address.edit.gender.female")
        }
    }

}
