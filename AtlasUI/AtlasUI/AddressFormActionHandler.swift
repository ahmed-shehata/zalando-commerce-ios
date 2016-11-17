//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AddressFormActionHandlerCompletion = (EquatableAddress) -> Void

protocol AddressFormActionHandlerDelegate: NSObjectProtocol {

    func addressProcessingFinished()
    func dismissView(animated: Bool, completion: (() -> Void)?)

}

protocol AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate? { get set }
    var completion: AddressFormActionHandlerCompletion? { get set }

    func procces(withValidModel dataModel: AddressFormDataModel)

}

extension AddressFormActionHandler {

    func submitButtonPressed(dataModel: AddressFormDataModel) {
        guard let request = CheckAddressRequest(dataModel: dataModel) else {
            delegate?.addressProcessingFinished()
            return
        }

        AtlasUIClient.checkAddress(request) { result in
            guard let checkAddressResponse = result.process() else  {
                self.delegate?.addressProcessingFinished()
                return
            }

            if checkAddressResponse.status == .notCorrect {
                UserMessage.displayError(AtlasCheckoutError.addressInvalid)
                self.delegate?.addressProcessingFinished()
            } else {
                self.procces(withValidModel: dataModel)
            }
        }
    }

}

extension CheckAddressRequest {

    init?(dataModel: AddressFormDataModel) {
        guard let address = CheckAddress(dataModel: dataModel) else { return nil }

        self.address = address
        self.pickupPoint = PickupPoint(dataModel: dataModel)
    }

}

extension CheckAddress {

    init?(dataModel: AddressFormDataModel) {
        guard let
            zip = dataModel.zip,
            city = dataModel.city,
            countryCode = dataModel.countryCode else { return nil }

        self.street = dataModel.street
        self.additional = dataModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
    }
    
}

