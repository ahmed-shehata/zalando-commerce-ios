//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

protocol AddressFormActionHandlerDelegate: NSObjectProtocol {

    func addressProcessingFinished()
    func updateView(withDataModel dataModel: AddressFormDataModel)
    func dismissView(withAddress address: EquatableAddress, animated: Bool)

}

protocol AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate? { get set }

    func submit(dataModel: AddressFormDataModel)

}

extension AddressFormActionHandler {

    func validateAddress(dataModel: AddressFormDataModel, completion: @escaping NormalizedAddressCompletion) {
        guard
            let request = CheckAddressRequest(dataModel: dataModel),
            let userCheckAddress = CheckAddress(dataModel: dataModel) else {
                completion(.error)
                return
        }

        AtlasUIClient.checkAddress(request) { result in
            guard let checkAddressResponse = result.process() else {
                completion(.error)
                return
            }

            switch checkAddressResponse.status {
            case .correct:
                completion(.selectAddress(address: userCheckAddress))
            case .notCorrect:
                UserMessage.displayError(error: AtlasCheckoutError.addressInvalid)
                completion(.error)
            case .normalized:
                let viewController = NormalizedAddressViewController(userAddress: userCheckAddress,
                                                                     normalizedAddress: checkAddressResponse.normalizedAddress,
                                                                     completion: completion)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overCurrentContext
                AtlasUIViewController.shared?.show(navigationController, sender: nil)
            }
        }
    }

}
