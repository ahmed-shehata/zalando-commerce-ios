//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI
import AtlasSDK

class AddressBookImportCreationStrategy: NSObject, AddressFormCreationStrategy {

    let countryCode: String
    let completion: AddressFormCreationStrategyCompletion

    required init(countryCode: String, completion: AddressFormCreationStrategyCompletion) {
        self.countryCode = countryCode
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

extension AddressBookImportCreationStrategy: CNContactPickerDelegate {

    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            guard let strongSelf = self else { return }
            if let addressViewModel = AddressFormViewModel(contactProperty: contactProperty, countryCode: strongSelf.countryCode) {
                strongSelf.completion(addressViewModel)
            } else {
                UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }
    }

}
