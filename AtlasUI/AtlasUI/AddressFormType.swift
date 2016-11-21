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
        return "\(rawValue.lowercaseString)-textfield"
    }

    var title: String {
        let title = Localizer.string("addressFormView.\(rawValue.lowercaseString)")
        return title + (formValidators.contains { $0 == .Required } ? "*" : "")
    }

    func value(dataModel: AddressFormDataModel) -> String? {
        switch self {
        case .title: return dataModel.localizedTitle()
        case .firstName: return dataModel.firstName
        case .lastName: return dataModel.lastName
        case .street: return dataModel.street
        case .additional: return dataModel.additional
        case .packstation: return dataModel.pickupPointId
        case .memberID: return dataModel.pickupPointMemberId
        case .zipcode: return dataModel.zip
        case .city: return dataModel.city
        case .country: return Localizer.countryName(forCountryCode: dataModel.countryCode)
        }
    }

    func updateModel(dataModel: AddressFormDataModel, withValue value: String?) {
        switch self {
        case .title: dataModel.updateTitle(value)
        case .firstName: dataModel.firstName = value
        case .lastName: dataModel.lastName = value
        case .street: dataModel.street = value
        case .additional: dataModel.additional = value
        case .packstation: dataModel.pickupPointId = value
        case .memberID: dataModel.pickupPointMemberId = value
        case .zipcode: dataModel.zip = value
        case .city: dataModel.city = value
        case .country: break
        }
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

    func customView(dataModel: AddressFormDataModel, completion: TextFieldChangedHandler) -> UIView? {
        switch self {
        case .title:
            let titles = dataModel.titles
            let currentTitle = value(dataModel) ?? ""
            let currentTitleIdx = titles.indexOf(currentTitle) ?? 0
            return PickerKeyboardInputView(pickerData: titles, startingValueIndex: currentTitleIdx, completion: completion)
        default:
            return nil
        }
    }

    var formValidators: [FormValidator] {
        switch self {
        case .title:
            return [.Required]
        case .firstName, .lastName:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.namePattern, errorMessage: "formValidation.pattern.name")]
        case .street:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.streetPattern, errorMessage: "formValidation.pattern.street")]
        case .additional:
            return [.MaxLength(maxLength: 50)]
        case .packstation:
            return [.Required,
                    .ExactLength(length: 3),
                    .NumbersOnly]
        case .memberID:
            return [.Required,
                    .MinLength(minLength: 3),
                    .NumbersOnly]
        case .zipcode:
            return [.Required,
                    .ExactLength(length: 5),
                    .NumbersOnly]
        case .city:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.cityPattern, errorMessage: "formValidation.pattern.city")]
        case .country:
            return [.Required]
        }
    }

}
