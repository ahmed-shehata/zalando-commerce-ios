//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI
import AtlasSDK

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
                let dataModel = try AddressFormDataModel(contactProperty: contactProperty,
                                                         countryCode: AtlasAPIClient.shared?.config.salesChannel.countryCode)
                self?.completion(dataModel)
            } catch let error {
                UserMessage.displayError(error: error)
            }
        }
    }

}
