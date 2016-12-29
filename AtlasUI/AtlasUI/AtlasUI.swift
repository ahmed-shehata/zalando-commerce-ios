//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasUICompletion = (AtlasResult<AtlasUI>) -> Void

final public class AtlasUI {

    public enum Error: AtlasError {

        case notInitialized

    }

    public let client: AtlasAPIClient

    private static var _shared: AtlasUI?

    static func shared() throws -> AtlasUI {
        guard let shared = _shared else { throw Error.notInitialized }
        return shared
    }

    fileprivate let injector = Injector()

    private init(client: AtlasAPIClient, localizer: Localizer) {
        self.client = client
        self.register { localizer }
    }

    public static func configure(options: Options? = nil, completion: @escaping AtlasUICompletion) {
        Atlas.configure(options: options) { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))

            case .success(let client):
                do {
                    let localizer = try Localizer(localeIdentifier: client.config.interfaceLocale.identifier)
                    let shared = AtlasUI(client: client, localizer: localizer)
                    AtlasUI._shared = shared
                    completion(.success(shared))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController, forSKU sku: String) throws {
        guard let _ = AtlasAPIClient.shared else {
            AtlasLogger.logError("AtlasUI is not initialized")
            throw AtlasUI.Error.notInitialized
        }

        let atlasUIViewController = AtlasUIViewController(forSKU: sku)

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

extension AtlasAPIClient {

    static var shared: AtlasAPIClient? {
        return try? AtlasUI.shared().client
    }

}
