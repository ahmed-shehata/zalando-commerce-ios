//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AddressViewModelCreationStrategyCompletion = (_ addressViewModel: AddressFormViewModel) -> Void

protocol AddressViewModelCreationStrategy {

    // TODO: consider renaming
    func setStrategyCompletion(_ completion: AddressViewModelCreationStrategyCompletion?)
    func execute()

}

extension AddressViewModelCreationStrategy {

    func showActionSheet(dataModelStrategies strategies: [AddressDataModelCreationStrategy]) {
        let title = Localizer.string("addressListView.add.type.title")

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { (UIAlertAction) in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

}
