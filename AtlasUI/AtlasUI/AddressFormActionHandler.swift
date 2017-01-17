//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

protocol AddressFormActionHandlerDelegate: NSObjectProtocol {

    func addressProcessingFinished()
    func dismissView(withAddress address: EquatableAddress, animated: Bool)

}

protocol AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate? { get set }

    func submit(dataModel: AddressFormDataModel)

}

extension AddressFormActionHandler {

    func validateAddress(dataModel: AddressFormDataModel, completion: @escaping (Bool) -> Void) {
        guard let request = CheckAddressRequest(dataModel: dataModel) else {
            completion(false)
            return
        }

        AtlasUIClient.checkAddress(request) { result in
            guard let checkAddressResponse = result.process() else {
                completion(false)
                return
            }

            switch checkAddressResponse.status {
            case .correct:
                completion(true)
            case .notCorrect:
                UserMessage.displayError(error: AtlasCheckoutError.addressInvalid)
                completion(false)
            case .normalized:
                guard let userAddress = CheckAddress(dataModel: dataModel) else { return }
                let normalizedAddress = checkAddressResponse.normalizedAddress
                let viewController = NormalizedAddressViewController(userAddress: userAddress, normalizedAddress: normalizedAddress)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .overCurrentContext
                AtlasUIViewController.shared?.show(navigationController, sender: nil)
            }
        }
    }

}
