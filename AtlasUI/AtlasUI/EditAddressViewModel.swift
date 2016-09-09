//
//  EditAddressViewModel.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 08/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EditAddressViewModel {

    var id: String?
    var customerNumber: String?
    var gender: Gender?
    var firstName: String?
    var lastName: String?
    var street: String?
    var additional: String?
    var zip: String?
    var city: String?
    var countryCode: String?
    var pickupPoint: PickupPoint?

}

infix operator --> { associativity left precedence 140 }
func --> (left: UserAddress, right: EditAddressViewModel.Type) -> EditAddressViewModel {
    let addressViewModel = EditAddressViewModel()
    addressViewModel.id = left.id
    addressViewModel.customerNumber = left.customerNumber
    addressViewModel.gender = left.gender
    addressViewModel.firstName = left.firstName
    addressViewModel.lastName = left.lastName
    addressViewModel.street = left.street
    addressViewModel.additional = left.additional
    addressViewModel.zip = left.zip
    addressViewModel.city = left.city
    addressViewModel.countryCode = left.countryCode
    addressViewModel.pickupPoint = left.pickupPoint
    return addressViewModel
}
