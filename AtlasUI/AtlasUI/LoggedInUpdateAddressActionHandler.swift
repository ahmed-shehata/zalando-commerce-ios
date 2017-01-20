//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct LoggedInUpdateAddressActionHandler: AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate?

    func submit(dataModel: AddressFormDataModel) {
        validateAddress(dataModel: dataModel) { result in
            guard case .selectAddress(let selectedAddress) = result else {
                if case .editAddress(let editAddress) = result {
                    dataModel.update(forCheckAddress: editAddress)
                    self.delegate?.updateView(withDataModel: dataModel)
                }
                self.delegate?.addressProcessingFinished()
                return
            }

            dataModel.update(forCheckAddress: selectedAddress)
            self.delegate?.updateView(withDataModel: dataModel)

            guard let addressId = dataModel.addressId,
                let request = UpdateAddressRequest(dataModel: dataModel) else {
                    self.delegate?.addressProcessingFinished()
                    return
            }

            AtlasUIClient.updateAddress(addressId: addressId, request: request) { result in
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
        guard let gender = dataModel.gender,
            let firstName = dataModel.firstName,
            let lastName = dataModel.lastName,
            let zip = dataModel.zip,
            let city = dataModel.city,
            let countryCode = dataModel.countryCode
            else { return nil }

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
