//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI
import AtlasSDK

@testable import AtlasUI

class UITestCase: XCTestCase {

    var sku = ConfigSKU(value: "AD541L009-G11")
    var atlasUIViewController: AtlasUIViewController?
    var atlasUI: AtlasUI!

    var window: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = .white
        return window
    }()

    var defaultNavigationController: UINavigationController? {
        return atlasUIViewController?.mainNavigationController
    }

    override class func setUp() {
        super.setUp()
        Nimble.AsyncDefaults.Timeout = 10
        try! AtlasMockAPI.startServer()
    }

    func registerAtlasUI() {
        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            AtlasUI.configure(options: opts) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let atlasUI):
                    self.atlasUI = atlasUI
                }
                done()
            }
        }
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    override func setUp() {
        super.setUp()
        registerAtlasUI()
        registerAtlasUIViewController(for: self.sku)
        waitForArticleFetch()
    }

    func registerAtlasUIViewController(forConfigSKU sku: String) {
        let sku = ConfigSKU(value: sku)
        registerAtlasUIViewController(for: sku)
    }

    func registerAtlasUIViewController(for sku: ConfigSKU) {
        UserError.resetBanners()
        let atlasUIViewController = AtlasUIViewController(forSKU: sku, atlasUI: atlasUI) { _ in }
        self.window.rootViewController = atlasUIViewController
        self.window.makeKeyAndVisible()
        _ = atlasUIViewController.view // load the view
        self.atlasUIViewController = atlasUIViewController
    }

    private func waitForArticleFetch() {
        expect(self.atlasUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController).toEventuallyNot(beNil())
        guard let checkoutSummary = self.atlasUIViewController?.mainNavigationController.viewControllers.last as? CheckoutSummaryViewController else { return fail() }
        if checkoutSummary.checkoutContainer.collectionView.numberOfItems(inSection: 0) > 0 {
            checkoutSummary.checkoutContainer.collectionView.collectionView(checkoutSummary.checkoutContainer.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            expect(checkoutSummary.checkoutContainer.overlayButton.isHidden).toEventually(beTrue())
        }
    }

    var errorDisplayed: Bool {
        guard let errorPresenterViewController = atlasUIViewController?.presentedViewController ?? atlasUIViewController else { return false }
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
