//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AddressViewModelCreationStrategyCompletion = (addressViewModel: AddressFormViewModel) -> Void

protocol AddressViewModelCreationStrategy {

    func configure(withTitle titleLocalizedKey: String?, completion: AddressViewModelCreationStrategyCompletion?)
    func execute()

}

extension AddressViewModelCreationStrategy {

    func showActionSheet(titleLocalizedKey: String?, strategies: [AddressDataModelCreationStrategy]) {
        let title: String?
        if let key = titleLocalizedKey {
            title = Localizer.string(key)
        } else {
            title = nil
        }

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { _ in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

}
