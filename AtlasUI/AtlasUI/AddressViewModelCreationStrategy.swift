//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AddressViewModelCreationStrategyCompletion = (_ addressViewModel: AddressFormViewModel) -> Void

protocol AddressViewModelCreationStrategy {

    var strategyCompletion: AddressViewModelCreationStrategyCompletion? { get set }
    func execute()

}

extension AddressViewModelCreationStrategy {

    func presentSelection(forStrategies strategies: [AddressDataModelCreationStrategy]) {
        let title = Localizer.format(string: "addressListView.add.type.title")

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { (UIAlertAction) in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.format(string: "button.general.cancel"), style: .cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.presentSelection(title: title, actions: buttonActions)
    }

}
