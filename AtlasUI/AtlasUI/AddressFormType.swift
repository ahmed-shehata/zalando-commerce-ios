//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum AddressFormType {
    case standardAddress
    case pickupPoint

    var fields: [AddressFormField] {
        switch self {
        case .standardAddress: return [.title, .firstName, .lastName, .street, .additional, .zipcode, .city, .country]
        case .pickupPoint: return [.title, .firstName, .lastName, .packstation, .memberID, .zipcode, .city, .country]
        }
    }
}

enum AddressFormField: String {
    case title
    case firstName
    case lastName
    case street
    case additional
    case packstation
    case memberID
    case zipcode
    case city
    case country

    var accessibilityIdentifier: String {
        return "\(rawValue.lowercased())-textfield"
    }

    var title: String {
        let title = Localizer.format(string: "addressFormView.\(rawValue.lowercased())")
        return title + (formValidators.contains { $0 == .required } ? "*" : "")
    }

    func isActive() -> Bool {
        return self != .country
    }

    func returnKeyDismissKeyboard() -> Bool {
        switch self {
        case .city, .country: return true
        default: return false
        }
    }

    func customView(_ dataModel: AddressFormDataModel, completion: @escaping TextFieldChangedHandler) -> UIView? {
        switch self {
        case .title:
            return PickerKeyboardInputView(pickerData: dataModel.titles,
                                           startingValueIndex: dataModel.selectedTitleIndex(),
                                           completion: completion)
        default:
            return nil
        }
    }

    var formValidators: [FormValidator] {
        switch self {
        case .title:
            return [.required]
        case .firstName, .lastName:
            return [.required,
                    .maxLength(maxLength: 50),
                    .minLength(minLength: 2),
                    .pattern(pattern: FormValidator.namePattern, errorMessage: "formValidation.pattern.name")]
        case .street:
            return [.required,
                    .maxLength(maxLength: 50),
                    .minLength(minLength: 2),
                    .pattern(pattern: FormValidator.streetPattern, errorMessage: "formValidation.pattern.street")]
        case .additional:
            return [.maxLength(maxLength: 50)]
        case .packstation:
            return [.required,
                    .exactLength(length: 3),
                    .numbersOnly]
        case .memberID:
            return [.required,
                    .minLength(minLength: 3),
                    .numbersOnly]
        case .zipcode:
            return [.required,
                    .exactLength(length: 5),
                    .numbersOnly]
        case .city:
            return [.required,
                    .maxLength(maxLength: 50),
                    .minLength(minLength: 2),
                    .pattern(pattern: FormValidator.cityPattern, errorMessage: "formValidation.pattern.city")]
        case .country:
            return [.required]
        }
    }

}

extension AddressFormDataModel {

    fileprivate func selectedTitleIndex() -> Int {
        guard let title = self.localizedTitle() else { return 0 }
        return titles.index(of: title) ?? 0
    }

    func value(forField field: AddressFormField) -> String? {
        switch field {
        case .title: return self.localizedTitle()
        case .firstName: return self.firstName
        case .lastName: return self.lastName
        case .street: return self.street
        case .additional: return self.additional
        case .packstation: return self.pickupPointId
        case .memberID: return self.pickupPointMemberId
        case .zipcode: return self.zip
        case .city: return self.city
        case .country: return Localizer.countryName(forCountryCode: self.countryCode)
        }
    }

    func update(value: String?, fromField field: AddressFormField) {
        switch field {
        case .title: self.updateTitle(fromLocalizedGenderText: value)
        case .firstName: self.firstName = value
        case .lastName: self.lastName = value
        case .street: self.street = value
        case .additional: self.additional = value
        case .packstation: self.pickupPointId = value
        case .memberID: self.pickupPointMemberId = value
        case .zipcode: self.zip = value
        case .city: self.city = value
        case .country: break
        }
    }
}
