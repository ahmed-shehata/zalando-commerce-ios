//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class AddressFormViewModel {

    var gender: Gender?
    var firstName: String?
    var lastName: String?
    var street: String?
    var additional: String?
    var pickupPointId: String?
    var pickupPointMemberId: String?
    var zip: String?
    var city: String?

    let countryCode: String
    let isDefaultBilling: Bool
    let isDefaultShipping: Bool

    init (equatableAddress: EquatableAddress? = nil, countryCode: String) {
        if let userAddress = equatableAddress as? UserAddress {
            isDefaultBilling = userAddress.isDefaultBilling
            isDefaultShipping = userAddress.isDefaultShipping
        } else {
            isDefaultBilling = false
            isDefaultShipping = false
        }
        self.countryCode = countryCode

        guard let equatableAddress = equatableAddress else { return }

        gender = equatableAddress.gender
        firstName = equatableAddress.firstName
        lastName = equatableAddress.lastName
        street = equatableAddress.street
        additional = equatableAddress.additional
        pickupPointId = equatableAddress.pickupPoint?.id
        pickupPointMemberId = equatableAddress.pickupPoint?.memberId
        zip = equatableAddress.zip
        city = equatableAddress.city
    }

    internal var titles: [String] {
        return ["", Gender.male.title, Gender.female.title]
    }

    internal func updateTitle(localizedGenderText: String?) {
        switch localizedGenderText {
        case Gender.male.title?: gender = .male
        case Gender.female.title?: gender = .female
        default: gender = nil
        }
    }

    internal func localizedTitle() -> String? {
        return gender?.title
    }

}

extension CreateAddressRequest {

    internal init? (addressFormViewModel: AddressFormViewModel) {

        guard let
        gender = addressFormViewModel.gender,
            firstName = addressFormViewModel.firstName,
            lastName = addressFormViewModel.lastName,
            zip = addressFormViewModel.zip,
            city = addressFormViewModel.city else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = addressFormViewModel.countryCode
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
        self.defaultBilling = addressFormViewModel.isDefaultBilling
        self.defaultShipping = addressFormViewModel.isDefaultShipping
    }

}

extension UpdateAddressRequest {

    internal init? (addressFormViewModel: AddressFormViewModel) {

        guard let
        gender = addressFormViewModel.gender,
            firstName = addressFormViewModel.firstName,
            lastName = addressFormViewModel.lastName,
            zip = addressFormViewModel.zip,
            city = addressFormViewModel.city else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = addressFormViewModel.countryCode
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
        self.defaultBilling = addressFormViewModel.isDefaultBilling
        self.defaultShipping = addressFormViewModel.isDefaultShipping
    }

}

extension CheckAddressRequest {

    internal init? (addressFormViewModel: AddressFormViewModel) {

        guard let address = CheckAddress(addressFormViewModel: addressFormViewModel) else { return nil }

        self.address = address
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
    }

}

extension PickupPoint {

    internal init? (addressFormViewModel: AddressFormViewModel) {

        guard let
        pickupPointId = addressFormViewModel.pickupPointId,
            pickupPointMemberId = addressFormViewModel.pickupPointMemberId else { return nil }

        self.id = pickupPointId
        self.name = "PACKSTATION"
        self.memberId = pickupPointMemberId
    }

}

extension CheckAddress {

    internal init? (addressFormViewModel: AddressFormViewModel) {

        guard let
        zip = addressFormViewModel.zip,
            city = addressFormViewModel.city else { return nil }

        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = addressFormViewModel.countryCode
    }

}

extension Gender {

    private var title: String {
        return Localizer.string("addressFormView.gender.\(rawValue.lowercaseString)")
    }

}
