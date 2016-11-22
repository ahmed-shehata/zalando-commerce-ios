//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class GuestCheckoutUpdateAddressActionHandler: AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate?

    func process(validDataModel dataModel: AddressFormDataModel) {
        guard let address = GuestCheckoutAddress(fromDataModelForUpdateAddress: dataModel) else {
            UserMessage.displayError(AtlasCheckoutError.unclassified)
            delegate?.addressProcessingFinished()
            return
        }

        delegate?.dismissView(withAddress: address, animated: true)
    }

}

extension GuestCheckoutAddress {

    private init?(fromDataModelForUpdateAddress dataModel: AddressFormDataModel) {
        guard let
            id = dataModel.addressId,
            gender = dataModel.gender,
            firstName = dataModel.firstName,
            lastName = dataModel.lastName,
            zip = dataModel.zip,
            city = dataModel.city,
            countryCode = dataModel.countryCode else { return nil }

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
