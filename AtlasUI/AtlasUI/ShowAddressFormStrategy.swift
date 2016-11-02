//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import ContactsUI
import AtlasSDK

enum ShowAddressFormStrategyType {

    case newAddress
    case fromAddressBook(contactProperty: CNContactProperty)

}

typealias ShowAddressFormStrategyCompletion = (type: ShowAddressFormStrategyType) -> Void

class ShowAddressFormStrategy: NSObject {

    var completion: ShowAddressFormStrategyCompletion

    init(completion: ShowAddressFormStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        let yesButton = ButtonAction(text: "YES") { [weak self] _ in
            self?.showAddressBook()
        }
        let noButton = ButtonAction(text: "NO") { [weak self] _ in
            self?.completion(type: .newAddress)
        }
        UserMessage.showAlert("Import address", message: "Import Address from Address book?", actions: yesButton, noButton)
    }

    private func showAddressBook() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPostalAddressesKey]
        contactPickerViewController.predicateForSelectionOfProperty = NSPredicate(format: "key == 'postalAddresses'")
        contactPickerViewController.delegate = self
        contactPickerViewController.modalPresentationStyle = .OverFullScreen
        AtlasUIViewController.instance?.showViewController(contactPickerViewController, sender: nil)
    }

}

extension ShowAddressFormStrategy: CNContactPickerDelegate {

    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            self?.completion(type: .fromAddressBook(contactProperty: contactProperty))
        }
    }

}
