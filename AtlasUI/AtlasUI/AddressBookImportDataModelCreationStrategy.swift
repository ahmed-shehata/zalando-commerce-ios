//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI
import AtlasSDK

// swiftlint:disable:next type_name
class AddressBookImportDataModelCreationStrategy: NSObject, AddressDataModelCreationStrategy {

    let completion: AddressDataModelCreationStrategyCompletion

    required init(completion: AddressDataModelCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
        contactPickerViewController.predicateForSelectionOfProperty = NSPredicate(format: "key == 'postalAddresses'")
        contactPickerViewController.delegate = self
        contactPickerViewController.modalPresentationStyle = .OverCurrentContext
        AtlasUIViewController.instance?.showViewController(contactPickerViewController, sender: nil)
    }

}

extension AddressBookImportDataModelCreationStrategy: CNContactPickerDelegate {

    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            guard let strongSelf = self else { return }
            if let datawModel = AddressFormDataModel(contactProperty: contactProperty, countryCode: AtlasAPIClient.countryCode) {
                strongSelf.completion(datawModel)
            } else {
                UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }
    }

}
