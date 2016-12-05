//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias AddressViewModelCreationStrategyCompletion = (_ addressViewModel: AddressFormViewModel) -> Void

protocol AddressViewModelCreationStrategy {

    var strategyCompletion: AddressViewModelCreationStrategyCompletion? { get set }
    var titleKey: String? { get set }

    func execute()

}

extension AddressViewModelCreationStrategy {

    func presentSelection(forStrategies strategies: [AddressDataModelCreationStrategy]) {
        let title: String?
        if let key = titleKey {
            title = Localizer.format(string: key)
        } else {
            title = nil
        }

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { _ in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.format(string: "button.general.cancel"), style: .cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

}
