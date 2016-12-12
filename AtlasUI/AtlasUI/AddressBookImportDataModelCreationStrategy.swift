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
            do {
                let datawModel = try AddressFormDataModel(contactProperty: contactProperty,
                                                          countryCode: AtlasAPIClient.shared?.salesChannelCountry)
                self?.completion(datawModel)
            } catch let error {
                UserMessage.displayError(error: error)
            }
        }
    }

}
