//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class GuestCheckoutCreateAddressActionHandler: AddressFormActionHandler {

    weak var delegate: AddressFormActionHandlerDelegate?

    func submit(dataModel: AddressFormDataModel) {
        guard let address = GuestCheckoutAddress(fromDataModelForCreateAddress: dataModel) else {
            UserError.display(error: CheckoutError.unclassified)
            delegate?.addressProcessingFinished()
            return
        }

        delegate?.dismissView(with: address, animated: true)
    }

}

extension GuestCheckoutAddress {

    fileprivate init?(fromDataModelForCreateAddress dataModel: AddressFormDataModel) {
        guard let gender = dataModel.gender,
            let firstName = dataModel.firstName,
            let lastName = dataModel.lastName,
            let zip = dataModel.zip,
            let city = dataModel.city,
            let countryCode = dataModel.countryCode
            else { return nil }

        self.id = ""
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
