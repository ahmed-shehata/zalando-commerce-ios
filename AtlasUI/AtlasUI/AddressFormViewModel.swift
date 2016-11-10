//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import ContactsUI

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
    var countryCode: String?

    let isDefaultBilling: Bool
    let isDefaultShipping: Bool

    init (equatableAddress: EquatableAddress? = nil) {
        if let userAddress = equatableAddress as? UserAddress {
            isDefaultBilling = userAddress.isDefaultBilling
            isDefaultShipping = userAddress.isDefaultShipping
        } else {
            isDefaultBilling = false
            isDefaultShipping = false
        }

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
        countryCode = AtlasAPIClient.instance?.config.salesChannel.countryCode
    }

    init?(contactProperty: CNContactProperty) {
        guard let postalAddress = contactProperty.value as? CNPostalAddress else { return nil }
        self.firstName = contactProperty.contact.givenName
        self.lastName = contactProperty.contact.familyName
        let streetComponents = postalAddress.street.componentsSeparatedByString("\n")
        self.street = streetComponents.first
        if streetComponents.count > 1 && !streetComponents[1].isEmpty {
            self.additional = streetComponents[1]
        }
        self.zip = postalAddress.postalCode
        self.city = postalAddress.city
        self.countryCode = AtlasAPIClient.instance?.config.salesChannel.countryCode
        self.isDefaultBilling = false
        self.isDefaultShipping = false
    }

    var titles: [String] {
        return ["", Gender.male.title, Gender.female.title]
    }

    func updateTitle(localizedGenderText: String?) {
        switch localizedGenderText {
        case Gender.male.title?: gender = .male
        case Gender.female.title?: gender = .female
        default: gender = nil
        }
    }

    func localizedTitle() -> String? {
        return gender?.title
    }

}

extension CreateAddressRequest {

    init? (addressFormViewModel: AddressFormViewModel) {

        guard let
            gender = addressFormViewModel.gender,
            firstName = addressFormViewModel.firstName,
            lastName = addressFormViewModel.lastName,
            zip = addressFormViewModel.zip,
            city = addressFormViewModel.city,
            countryCode = addressFormViewModel.countryCode else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
        self.defaultBilling = addressFormViewModel.isDefaultBilling
        self.defaultShipping = addressFormViewModel.isDefaultShipping
    }

}

extension UpdateAddressRequest {

    init? (addressFormViewModel: AddressFormViewModel) {

        guard let
            gender = addressFormViewModel.gender,
            firstName = addressFormViewModel.firstName,
            lastName = addressFormViewModel.lastName,
            zip = addressFormViewModel.zip,
            city = addressFormViewModel.city,
            countryCode = addressFormViewModel.countryCode else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
        self.defaultBilling = addressFormViewModel.isDefaultBilling
        self.defaultShipping = addressFormViewModel.isDefaultShipping
    }

}

extension CheckAddressRequest {

    init? (addressFormViewModel: AddressFormViewModel) {

        guard let address = CheckAddress(addressFormViewModel: addressFormViewModel) else { return nil }

        self.address = address
        self.pickupPoint = PickupPoint(addressFormViewModel: addressFormViewModel)
    }

}

extension PickupPoint {

    init? (addressFormViewModel: AddressFormViewModel) {

        guard let
        pickupPointId = addressFormViewModel.pickupPointId,
            pickupPointMemberId = addressFormViewModel.pickupPointMemberId else { return nil }

        self.id = pickupPointId
        self.name = "PACKSTATION"
        self.memberId = pickupPointMemberId
    }

}

extension CheckAddress {

    init? (addressFormViewModel: AddressFormViewModel) {

        guard let
            zip = addressFormViewModel.zip,
            city = addressFormViewModel.city,
            countryCode = addressFormViewModel.countryCode else { return nil }

        self.street = addressFormViewModel.street
        self.additional = addressFormViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
    }

}

extension Gender {

    private var title: String {
        return Localizer.string("addressFormView.gender.\(rawValue.lowercaseString)")
    }

}
