//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import ZalandoCommerceAPI

protocol AddressFormActionHandlerDelegate: class {

    func addressProcessingFinished()
    func updateView(with dataModel: AddressFormDataModel)
    func dismissView(with address: EquatableAddress, animated: Bool)

}

protocol AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate? { get set }

    func submit(dataModel: AddressFormDataModel)

}

extension AddressFormActionHandler {

    func validateAddress(dataModel: AddressFormDataModel, completion: @escaping AddressCheckViewControllerCompletion) {
        guard
            let request = CheckAddressRequest(dataModel: dataModel),
            let userCheckAddress = AddressCheck(dataModel: dataModel) else {
                completion(.error)
                return
        }

        ZalandoCommerceAPI.withLoader.checkAddress(request) { result in
            guard let checkAddressResponse = result.process() else {
                completion(.error)
                return
            }

            switch checkAddressResponse.status {
            case .correct:
                completion(.selectAddress(address: userCheckAddress))
            case .notCorrect:
                let header = Localizer.format(string: "addressCheckView.header.notCorrect")
                let originalAddress = AddressCheckDataModel.Address(title: Localizer.format(string: "addressCheckView.originalAddress"),
                                                                    address: userCheckAddress)

                let dataModel = AddressCheckDataModel(header: header, addresses: [originalAddress])
                self.displayAddressCheckView(dataModel: dataModel, completion: completion)
            case .normalized:
                let header = Localizer.format(string: "addressCheckView.header.normalized")
                let originalAddress = AddressCheckDataModel.Address(title: Localizer.format(string: "addressCheckView.originalAddress"),
                                                                    address: userCheckAddress)
                let normalizedAddress = AddressCheckDataModel.Address(title: Localizer.format(string: "addressCheckView.suggestedAddress"),
                                                                      address: checkAddressResponse.normalizedAddress)

                let dataModel = AddressCheckDataModel(header: header, addresses: [originalAddress, normalizedAddress])
                self.displayAddressCheckView(dataModel: dataModel, completion: completion)
            }
        }
    }

    private func displayAddressCheckView(dataModel: AddressCheckDataModel, completion: @escaping AddressCheckViewControllerCompletion) {
        let viewController = AddressCheckViewController(dataModel: dataModel, completion: completion)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        ZalandoCommerceUIViewController.presented?.show(navigationController, sender: nil)
    }

}
