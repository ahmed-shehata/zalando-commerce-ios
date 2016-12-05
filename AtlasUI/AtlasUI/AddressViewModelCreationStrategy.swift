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
        let title = actionSheetLocalizedTitle(titleLocalizedKey)

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { _ in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

    private func actionSheetLocalizedTitle(titleLocalizedKey: String?) -> String? {
        guard let key = titleLocalizedKey else { return nil }
        return Localizer.string(key)
    }

}
