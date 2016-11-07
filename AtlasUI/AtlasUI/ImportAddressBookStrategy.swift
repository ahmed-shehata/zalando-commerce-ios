//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import ContactsUI
import AtlasSDK

typealias ImportAddressBookStrategyCompletion = (CNContactProperty) -> Void

class ImportAddressBookStrategy: NSObject {

    var completion: ImportAddressBookStrategyCompletion?

    func execute() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
        contactPickerViewController.predicateForSelectionOfProperty = NSPredicate(format: "key == 'postalAddresses'")
        contactPickerViewController.delegate = self
        contactPickerViewController.modalPresentationStyle = .OverCurrentContext
        AtlasUIViewController.instance?.showViewController(contactPickerViewController, sender: nil)
    }

}

extension ImportAddressBookStrategy: CNContactPickerDelegate {

    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            self?.completion?(contactProperty)
        }
    }

}
