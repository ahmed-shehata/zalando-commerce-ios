//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutUpdateAddressActionHandler: AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate?

    func submit(dataModel: AddressFormDataModel) {
        guard let address = GuestCheckoutAddress(fromDataModelForUpdateAddress: dataModel) else {
            UserMessage.displayError(error: AtlasCheckoutError.unclassified)
            delegate?.addressProcessingFinished()
            return
        }

        delegate?.dismissView(withAddress: address, animated: true)
    }

}

extension GuestCheckoutAddress {

    fileprivate init?(fromDataModelForUpdateAddress dataModel: AddressFormDataModel) {
        guard let id = dataModel.addressId,
            let gender = dataModel.gender,
            let firstName = dataModel.firstName,
            let lastName = dataModel.lastName,
            let zip = dataModel.zip,
            let city = dataModel.city,
            let countryCode = dataModel.countryCode
            else { return nil }

        self.id = id
        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = dataModel.street
        self.additional = dataModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
        self.pickupPoint = PickupPoint(dataModel: dataModel)
    }

}