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
    var zCommerceUIViewController: ZalandoCommerceUIViewController?
    var zCommerceUI: ZalandoCommerceUI!

    var window: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = .white
        return window
    }()

    var defaultNavigationController: UINavigationController? {
        return zCommerceUIViewController?.mainNavigationController
    }

    override class func setUp() {
        super.setUp()
        Nimble.AsyncDefaults.Timeout = 10
        try! MockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! MockAPI.stopServer()
    }

    override func setUp() {
        super.setUp()
        registerZalandoCommerceUI()
        registerZalandoCommerceUIViewController(for: self.sku)
        waitForArticleFetch()
    }
    
    func registerZalandoCommerceUI() {
        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            ZalandoCommerceUI.configure(options: opts) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let zCommerceUI):
                    self.zCommerceUI = zCommerceUI
                }
                done()
            }
        }
    }

    func registerZalandoCommerceUIViewController(forConfigSKU sku: String) {
        let sku = ConfigSKU(value: sku)
        registerZalandoCommerceUIViewController(for: sku)
    }

    func registerZalandoCommerceUIViewController(for sku: ConfigSKU) {
        UserError.resetBanners()
        let zCommerceUIViewController = ZalandoCommerceUIViewController(forSKU: sku, uiInstance: zCommerceUI) { _ in }
        self.window.rootViewController = zCommerceUIViewController
        self.window.makeKeyAndVisible()
        _ = zCommerceUIViewController.view // load the view
        self.zCommerceUIViewController = zCommerceUIViewController
    }

    private func waitForArticleFetch() {
        expect(self.zCommerceUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController).toEventuallyNot(beNil())
        guard let checkoutSummary = self.zCommerceUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController else { return fail() }
        if checkoutSummary.checkoutContainer.collectionView.numberOfItems(inSection: 0) > 0 {
            checkoutSummary.checkoutContainer.collectionView.collectionView(checkoutSummary.checkoutContainer.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            expect(checkoutSummary.checkoutContainer.overlayButton.isHidden).toEventually(beTrue())
        }
    }

    var errorDisplayed: Bool {
        guard let errorPresenterViewController = zCommerceUIViewController?.presentedViewController ?? zCommerceUIViewController else { return false }
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
