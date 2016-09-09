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

//infix operator --> { associativity left precedence 140 }
//func -->(left: EditAddressViewModel, right: [Int]) -> [Int] { // 2
//
//}
