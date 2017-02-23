//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

// TODO: document it, please...

final public class AtlasUI {

    public enum Error: LocalizableError {

        case notInitialized

    }

    public let api: AtlasAPI

    private static var _shared: AtlasUI?

    static func shared() throws -> AtlasUI {
        guard let shared = _shared else { throw Error.notInitialized }
        return shared
    }

    fileprivate let injector = Injector()

    private init(api: AtlasAPI, localizer: Localizer) {
        self.api = api
        self.register { localizer }
    }

    public static func configure(options: Options? = nil, completion: @escaping Result<AtlasUI>) {
        Atlas.configure(options: options) { result in
            switch result {
            case .failure(let error):
                Logger.error(error)
                completion(.failure(error))

            case .success(let api):
                do {
                    let localeIdentifier = api.config.interfaceLocale.identifier
                    let localizer = try Localizer(localeIdentifier: localeIdentifier)
                    let shared = AtlasUI(api: api, localizer: localizer)
                    AtlasUI._shared = shared
                    completion(.success(shared))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

    /// `presentCheckout` is used to present the `AtlasUI` over the given controller
    /// It can be called only once at a time as it depends internally on singleton objects
    ///
    /// - Parameters:
    ///   - viewController: The controller in which `AtlasUI` will be presented over it
    ///   - sku: The SKU for the item that the user want to buy
    /// - Throws: `AtlasUI.Error.notInitialized` when `AtlasUI` is not finished `AtlasUI.configure(options:completion:)`
    public func presentCheckout(onViewController viewController: UIViewController, for sku: ConfigSKU) throws {
        guard let _ = AtlasAPI.shared else {
            Logger.error("AtlasUI is not initialized")
            throw AtlasUI.Error.notInitialized
        }

        let atlasUIViewController = AtlasUIViewController(for: sku)

        let checkoutTransitioning = CheckoutTransitioningDelegate()
        atlasUIViewController.transitioningDelegate = checkoutTransitioning
        atlasUIViewController.modalPresentationStyle = .custom

        injector.register { atlasUIViewController }

        viewController.present(atlasUIViewController, animated: true, completion: nil)
    }

}

extension AtlasUI {

    func register<T>(factory: @escaping (Void) -> T) {
        injector.register(factory)
    }

    func provide<T>() throws -> T {
        return try injector.provide()
    }

}

extension AtlasAPI {

    static var shared: AtlasAPI? {
        return try? AtlasUI.shared().api
    }

}
