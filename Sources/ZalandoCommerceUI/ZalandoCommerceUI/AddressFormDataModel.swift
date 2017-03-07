//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI
import ContactsUI

class AddressFormDataModel {

    var addressId: String?
    var gender: Gender?
    var firstName: String?
    var lastName: String?
    var email: String?
    var street: String?
    var additional: String?
    var pickupPointId: String?
    var pickupPointMemberId: String?
    var zip: String?
    var city: String?

    let countryCode: String?
    let isDefaultBilling: Bool
    let isDefaultShipping: Bool

    init(equatableAddress: EquatableAddress? = nil, email: String? = nil, countryCode: String?) {
        if let userAddress = equatableAddress as? UserAddress {
            isDefaultBilling = userAddress.isDefaultBilling
            isDefaultShipping = userAddress.isDefaultShipping
        } else {
            isDefaultBilling = false
            isDefaultShipping = false
        }
        self.email = email
        self.countryCode = countryCode

        guard let equatableAddress = equatableAddress else { return }

        addressId = equatableAddress.id
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

    init(contactProperty: CNContactProperty, email: String? = nil, countryCode: String?) throws {
        guard let postalAddress = contactProperty.value as? CNPostalAddress else { throw CheckoutError.unclassified }
        guard postalAddress.isoCountryCode.lowercased() == countryCode?.lowercased() else { throw CheckoutError.unsupportedCountry }

        self.firstName = contactProperty.contact.givenName
        self.lastName = contactProperty.contact.familyName
        self.email = email
        self.street = postalAddress.streetLine1
        self.additional = postalAddress.streetLine2
        self.zip = postalAddress.postalCode
        self.city = postalAddress.city
        self.countryCode = countryCode
        self.isDefaultBilling = false
        self.isDefaultShipping = false
    }

    let titles: [String] = ["", Gender.male.title, Gender.female.title]

    func updateTitle(fromLocalizedGenderText text: String?) {
        switch text {
        case Gender.male.title?:
            gender = .male
        case Gender.female.title?:
            gender = .female
        default:
            gender = nil
        }
    }

    func localizedTitle() -> String? {
        return gender?.title
    }

}

extension PickupPoint {

    init?(dataModel: AddressFormDataModel) {
        guard let pickupPointId = dataModel.pickupPointId,
            let pickupPointMemberId = dataModel.pickupPointMemberId
            else { return nil }

        self.id = pickupPointId
        self.name = "PACKSTATION"
        self.memberId = pickupPointMemberId
    }

}

extension Gender {

    fileprivate var title: String {
        return Localizer.format(string: "addressFormView.gender.\(rawValue.lowercased())")
    }

}

extension CheckAddressRequest {

    init?(dataModel: AddressFormDataModel) {
        guard let address = AddressCheck(dataModel: dataModel) else { return nil }

        self.address = address
        self.pickupPoint = PickupPoint(dataModel: dataModel)
    }

}

extension AddressCheck {

    init?(dataModel: AddressFormDataModel) {
        guard let zip = dataModel.zip,
            let city = dataModel.city,
            let countryCode = dataModel.countryCode
            else { return nil }

        self.street = dataModel.street
        self.additional = dataModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
    }

}

extension AddressFormDataModel {

    fileprivate var isNormalAddress: Bool {
        return pickupPointId == nil && pickupPointMemberId == nil
    }

    func update(from address: AddressCheck) {
        if isNormalAddress {
            street = address.street
            additional = address.additional
        }
        zip = address.zip
        city = address.city
    }

}
