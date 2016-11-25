//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct LoggedInUpdateAddressActionHandler: AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate?

    func submitButtonPressed(dataModel: AddressFormDataModel) {
        validateAddress(dataModel) { success in
            guard let
                addressId = dataModel.addressId,
                request = UpdateAddressRequest(dataModel: dataModel) where success
                else {
                    self.delegate?.addressProcessingFinished()
                    return
            }

            AtlasUIClient.updateAddress(addressId, request: request) { result in
                guard let address = result.process() else {
                    self.delegate?.addressProcessingFinished()
                    return
                }

                self.delegate?.dismissView(withAddress: address, animated: true)
            }
        }
    }

}

extension UpdateAddressRequest {

    init?(dataModel: AddressFormDataModel) {
        guard let
            gender = dataModel.gender,
            firstName = dataModel.firstName,
            lastName = dataModel.lastName,
            zip = dataModel.zip,
            city = dataModel.city,
            countryCode = dataModel.countryCode else { return nil }

        self.gender = gender
        self.firstName = firstName
        self.lastName = lastName
        self.street = dataModel.street
        self.additional = dataModel.additional
        self.zip = zip
        self.city = city
        self.countryCode = countryCode
        self.pickupPoint = PickupPoint(dataModel: dataModel)
        self.defaultBilling = dataModel.isDefaultBilling
        self.defaultShipping = dataModel.isDefaultShipping
    }

}
