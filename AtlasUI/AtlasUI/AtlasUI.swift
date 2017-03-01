//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

// TODO: document it, please...

final public class AtlasUI {

    public enum Error: LocalizableError {

        case notPresented

    }

    public let api: AtlasAPI
    let localizer: Localizer

    private init(api: AtlasAPI, localizer: Localizer) {
        self.api = api
        self.localizer = localizer
    }

    public static func configure(options: Options? = nil, completion: @escaping ResultCompletion<AtlasUI>) {
        AtlasAPI.configure(options: options) { result in
            switch result {
            case .failure(let error):
                Logger.error(error)
                completion(.failure(error))

            case .success(let api):
                do {
                    let localeIdentifier = api.config.interfaceLocale.identifier
                    let localizer = try Localizer(localeIdentifier: localeIdentifier)
                    let shared = AtlasUI(api: api, localizer: localizer)
                    completion(.success(shared))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController, for sku: ConfigSKU) {
        let atlasUIViewController = AtlasUIViewController(for: sku, atlasUI: self)

        let checkoutTransitioning = CheckoutTransitioningDelegate()
        atlasUIViewController.transitioningDelegate = checkoutTransitioning
        atlasUIViewController.modalPresentationStyle = .custom

        viewController.present(atlasUIViewController, animated: true, completion: nil)
    }

}

extension AtlasAPI {

    static var shared: AtlasAPI? {
        return try? AtlasUI.fromPresented().api
    }

}

extension AtlasUI {

    static func fromPresented() throws -> AtlasUI {
        guard let controller = AtlasUIViewController.presented else { throw Error.notPresented }
        return controller.atlasUI
    }

}

extension Config {

    static var shared: Config? {
        return AtlasAPI.shared?.config
    }

}
