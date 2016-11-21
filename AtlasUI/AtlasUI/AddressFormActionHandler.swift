//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressFormActionHandlerDelegate: NSObjectProtocol {

    func addressProcessingFinished()
    func dismissView(withAddress address: EquatableAddress, animated: Bool)

}

protocol AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate? { get set }

    func process(validDataModel dataModel: AddressFormDataModel)

}

extension AddressFormActionHandler {

    func submitButtonPressed(dataModel: AddressFormDataModel) {
        guard let request = CheckAddressRequest(dataModel: dataModel) else {
            delegate?.addressProcessingFinished()
            return
        }

        AtlasUIClient.checkAddress(request) { result in
            guard let checkAddressResponse = result.process() else {
                self.delegate?.addressProcessingFinished()
                return
            }

            if checkAddressResponse.status == .notCorrect {
                UserMessage.displayError(AtlasCheckoutError.addressInvalid)
                self.delegate?.addressProcessingFinished()
            } else {
                self.process(validDataModel: dataModel)
            }
        }
    }

}
