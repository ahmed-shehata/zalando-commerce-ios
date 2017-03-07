//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import MockAPI
import ZalandoCommerceAPI

@testable import ZalandoCommerceUI

class UITestCase: XCTestCase {

    var sku = ConfigSKU(value: "AD541L009-G11")
    var commerceUIViewController: ZalandoCommerceUIViewController?
    var commerceUI: ZalandoCommerceUI!

    var window: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = .white
        return window
    }()

    var defaultNavigationController: UINavigationController? {
        return commerceUIViewController?.mainNavigationController
    }

    override class func setUp() {
        super.setUp()
        Nimble.AsyncDefaults.Timeout = 10
        try! MockAPI.startServer()
    }

    func registerAtlasUI() {
        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            ZalandoCommerceUI.configure(options: opts) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let commerceUI):
                    self.commerceUI = commerceUI
                }
                done()
            }
        }
    }

    override class func tearDown() {
        super.tearDown()
        try! MockAPI.stopServer()
    }

    override func setUp() {
        super.setUp()
        registerAtlasUI()
        registerZalandoCommerceUIViewController(for: self.sku)
        waitForArticleFetch()
    }

    func registerZalandoCommerceUIViewController(forConfigSKU sku: String) {
        let sku = ConfigSKU(value: sku)
        registerZalandoCommerceUIViewController(for: sku)
    }

    func registerZalandoCommerceUIViewController(for sku: ConfigSKU) {
        UserError.resetBanners()
        let commerceUIViewController = ZalandoCommerceUIViewController(forSKU: sku, uiInstance: commerceUI) { _ in }
        self.window.rootViewController = commerceUIViewController
        self.window.makeKeyAndVisible()
        _ = commerceUIViewController.view // load the view
        self.commerceUIViewController = commerceUIViewController
    }

    private func waitForArticleFetch() {
        expect(self.commerceUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController).toEventuallyNot(beNil())
        guard let checkoutSummary = self.commerceUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController else { return fail() }
        if checkoutSummary.checkoutContainer.collectionView.numberOfItems(inSection: 0) > 0 {
            checkoutSummary.checkoutContainer.collectionView.collectionView(checkoutSummary.checkoutContainer.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            expect(checkoutSummary.checkoutContainer.overlayButton.isHidden).toEventually(beTrue())
        }
    }

    var errorDisplayed: Bool {
        guard let errorPresenterViewController = commerceUIViewController?.presentedViewController ?? commerceUIViewController else { return false }
        return errorPresenterViewController.childViewControllers.contains {
            $0 is BannerErrorViewController ||
            ($0 as? UINavigationController)?.viewControllers.first is FullScreenErrorViewController
        }
    }

    func retrieveView<T>(inView containerView: UIView) -> T? {
        guard let view = containerView as? T else {
            let subviews: [T] = containerView.subviews.flatMap {
                let subview: T? = retrieveView(inView: $0)
                return subview
            }
            return subviews.first
        }
        return view
    }

}
