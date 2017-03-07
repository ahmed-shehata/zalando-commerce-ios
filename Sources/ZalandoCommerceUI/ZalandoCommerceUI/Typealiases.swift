//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

typealias Completion<T> = (T) -> Void

typealias AddressCheckViewControllerCompletion = (AddressCheckResult) -> Void
typealias AddressDataModelCreationStrategyCompletion = (AddressFormDataModel) -> Void

typealias Email = String
typealias AddressFormCompletion = (EquatableAddress, Email?) -> Void

typealias AddressUpdatedHandler = (EquatableAddress) -> Void
typealias AddressDeletedHandler = (EquatableAddress) -> Void
typealias AddressSelectedHandler = (EquatableAddress) -> Void

typealias AddressViewModelCreationStrategyCompletion = (AddressFormViewModel) -> Void

typealias SelectedIndex = Int
typealias CheckoutSummaryArticleRefineCompletion = (SelectedIndex) -> Void
typealias CheckoutSummaryArticleRefineArrowHandler = (CheckoutSummaryArticleRefineType?, _ animated: Bool) -> Void
