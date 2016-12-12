//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI
import AtlasSDK

// swiftlint:disable:next type_name
class AddressBookImportDataModelCreationStrategy: NSObject, AddressDataModelCreationStrategy {

    let completion: AddressDataModelCreationStrategyCompletion

    required init(completion: @escaping AddressDataModelCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
        contactPickerViewController.predicateForSelectionOfProperty = NSPredicate(format: "key == 'postalAddresses'")
        contactPickerViewController.delegate = self
        contactPickerViewController.modalPresentationStyle = .overCurrentContext
        AtlasUIViewController.shared?.show(contactPickerViewController, sender: self)
    }

}

extension AddressBookImportDataModelCreationStrategy: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        picker.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            guard let postalAddress = contactProperty.value as? CNPostalAddress,
                postalAddress.isoCountryCode.lowercased() == AtlasAPIClient.shared?.salesChannelCountry.lowercased()
                else {
                    UserMessage.displayError(error: AtlasCheckoutError.unsupportedCountry)
                    return
            }

            if let datawModel = AddressFormDataModel(contactProperty: contactProperty,
                                                     countryCode: AtlasAPIClient.shared?.salesChannelCountry) {
                strongSelf.completion(datawModel)
            } else {
                UserMessage.displayError(error: AtlasCheckoutError.unclassified)
            }
        }
    }

}
