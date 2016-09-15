//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EditAddressViewModel {

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

    init (userAddress: EquatableAddress?, countryCode: String, isDefaultBilling: Bool = false, isDefaultShipping: Bool = false) {
        self.countryCode = countryCode
        self.isDefaultBilling = isDefaultBilling
        self.isDefaultShipping = isDefaultShipping

        guard let userAddress = userAddress else { return }

        gender = userAddress.gender
        firstName = userAddress.firstName
        lastName = userAddress.lastName
        street = userAddress.street
        additional = userAddress.additional
        pickupPointId = userAddress.pickupPoint?.id
        pickupPointMemberId = userAddress.pickupPoint?.memberId
        zip = userAddress.zip
        city = userAddress.city
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

extension UpdateAddressRequest {

    internal init? (addressViewModel: EditAddressViewModel) {

        guard let
            gender = addressViewModel.gender,
            firstName = addressViewModel.firstName,
            lastName = addressViewModel.lastName,
            zip = addressViewModel.zip,
            city = addressViewModel.city else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = addressViewModel.street
        self.additional = addressViewModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = addressViewModel.countryCode
        self.pickupPoint = PickupPoint(addressViewModel: addressViewModel)
        self.defaultBilling = addressViewModel.isDefaultBilling
        self.defaultShipping = addressViewModel.isDefaultShipping
    }

}

extension PickupPoint {

    internal init? (addressViewModel: EditAddressViewModel) {

        guard let
            pickupPointId = addressViewModel.pickupPointId,
            pickupPointMemberId = addressViewModel.pickupPointMemberId else { return nil }

        self.id = pickupPointId
        self.name = "PACKSTATION"
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
