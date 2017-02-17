//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasUIConfigureCompletion = (AtlasResult<AtlasUI>) -> Void
public typealias AtlasUICheckoutCompletion = (AtlasUI.CheckoutResult) -> Void

/// The main interface for Atlas UI framework
/// Only on instance of AtlasUI with a specific configuration can be created as a time as it is a singleton class
final public class AtlasUI {

    /// Errors that can thrown for AtlasUI Client
    ///
    /// - notInitialized: Indicate that the AtlasUI is not configured yet, make sure you call `configure(options:completion:)` first
    public enum Error: AtlasError {
        case notInitialized
    }

    /// Result that can returned after presenting the Checkout screen
    ///
    /// - orderPlaced: The user successfully placed the order
    ///                - orderConfirmation: The order confirmation object with the needed properties
    ///                - customerRequestedArticle: if not nil, then the customer is interested to view a specific product from the 
    ///                                            recommended products displayed after purchasing
    ///                                            Please open the product detail page for the given SKU
    /// - userCancelled: The user cancelled the checkout process
    /// - finishedWithError: Error is displayed to the user
    ///                      - error: The displayed error
    public enum CheckoutResult {
        case orderPlaced(orderConfirmation: OrderConfirmation, customerRequestedArticle: String?)
        case userCancelled
        case finishedWithError(error: AtlasError)
    }

    /// Reference for AtlasAPIClient object that is configured with the current SalesChannel
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

    /// Configure AtlasUI is used as the very starting point to use AtlasUI framework to configure it
    ///
    /// - Parameters:
    ///   - options: Options object with the needed configuration to initialize AtlasUI framework
    ///   - completion: Completion Block with `AtlasResult` as an input parameter having AtlasUI instance as the success value
    public static func configure(options: Options? = nil, completion: @escaping AtlasUIConfigureCompletion) {
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

    /// Present Checkout is used to present the AtlasUI over the given controller
    /// It can be called only once at a time as it depends internally on Singleton objects
    ///
    /// - Parameters:
    ///   - viewController: The controller in which AtlasUI will be presented over it
    ///   - sku: The SKU for the item that the user want to buy
    ///   - completion: Completion Block with `CheckoutResult` as an input parameter to indicate the result of the checkout process
    /// - Throws: notInitialized is thrown if this method is called before initializing AtlasUI be calling configure(options:completion:)
    public func presentCheckout(onViewController viewController: UIViewController,
                                forSKU sku: String,
                                completion: @escaping AtlasUICheckoutCompletion) throws {

        guard let _ = AtlasAPIClient.shared else {
            AtlasLogger.logError("AtlasUI is not initialized")
            throw AtlasUI.Error.notInitialized
        }

        let atlasUIViewController = AtlasUIViewController(forSKU: sku, completion: completion)

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
