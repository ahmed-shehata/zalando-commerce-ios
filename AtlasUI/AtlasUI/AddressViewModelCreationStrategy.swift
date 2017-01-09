//
//  Copyright © 2017 Zalando SE. All rights reserved.
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
        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { _ in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.format(string: "button.general.cancel"), style: .cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.presentSelection(title: messageTitle, actions: buttonActions)
    }

    private var messageTitle: String? {
        guard let key = titleKey else { return nil }
        return Localizer.format(string: key)
    }

}
