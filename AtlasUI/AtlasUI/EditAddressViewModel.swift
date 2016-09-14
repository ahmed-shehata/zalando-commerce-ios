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
    var customerNumber: String?
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

    init (userAddress: UserAddress?) {
        guard let userAddress = userAddress else { configureCountryCode(); return }
        id = userAddress.id
        customerNumber = userAddress.customerNumber
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
        isDefaultBilling = userAddress.isDefaultBilling
        isDefaultShipping = userAddress.isDefaultShipping
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

extension UserAddress {

    internal init? (addressViewModel: EditAddressViewModel) {

        guard let
            gender = addressViewModel.gender,
            firstName = addressViewModel.firstName,
            lastName = addressViewModel.lastName,
            zip = addressViewModel.zip,
            city = addressViewModel.city,
            countryCode = addressViewModel.countryCode else { return nil }

        self.id = addressViewModel.id ?? "" // TODO: May be Id is optional? ... or another model?
        self.customerNumber = addressViewModel.customerNumber ?? "" // TODO: Need to get customer number
        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressViewModel.street
        self.additional = addressViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
        self.pickupPoint = PickupPoint(addressViewModel: addressViewModel)
        self.isDefaultBilling = addressViewModel.isDefaultBilling
        self.isDefaultShipping = addressViewModel.isDefaultShipping
    }

}

extension PickupPoint {

    internal init? (addressViewModel: EditAddressViewModel) {

        guard let
            pickupPointName = addressViewModel.pickupPointName,
            pickupPointMemberId = addressViewModel.pickupPointMemberId else { return nil }

        self.id = "" // TODO: May be Id is optional? ... or another model?
        self.name = pickupPointName
        self.memberId = pickupPointMemberId
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
