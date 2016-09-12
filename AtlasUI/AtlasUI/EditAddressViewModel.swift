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
        guard let userAddress = userAddress else { return }
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

    internal func titles(localizer: LocalizerProviderType) -> [String] {
        return [Gender.male.title(localizer), Gender.female.title(localizer)]
    }
}

extension UserAddress {

    internal init? (addressViewModel: EditAddressViewModel) {

        guard let
            id = addressViewModel.id,
            customerNumber = addressViewModel.customerNumber,
            gender = addressViewModel.gender,
            firstName = addressViewModel.firstName,
            lastName = addressViewModel.lastName,
            zip = addressViewModel.zip,
            city = addressViewModel.city,
            countryCode = addressViewModel.countryCode else { return nil }

        self.id = id
        self.customerNumber = customerNumber
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
