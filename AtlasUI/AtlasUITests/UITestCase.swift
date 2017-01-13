//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI
import AtlasSDK

@testable import AtlasUI

class UITestCase: XCTestCase {

    var sku: String = "AD541L009-G11"
    var atlasUIViewController: AtlasUIViewController?
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
        try! AtlasMockAPI.startServer()

        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            AtlasUI.configure(options: opts) { result in
                if case let .failure(error) = result {
                    fail(String(describing: error))
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
        registerAtlasUIViewController(forSKU: sku)
    }

    func registerAtlasUIViewController(forSKU: String) {
        UserMessage.resetBanners()
        let atlasUIViewController = AtlasUIViewController(forSKU: forSKU)
        self.window.rootViewController = atlasUIViewController
        self.window.makeKeyAndVisible()
        try! AtlasUI.shared().register { atlasUIViewController }
        _ = atlasUIViewController.view // load the view
        self.atlasUIViewController = atlasUIViewController
    }

    var errorDisplayed: Bool {
        guard let errorPresenterViewController = atlasUIViewController?.presentedViewController ?? atlasUIViewController else { return false }
        return errorPresenterViewController.childViewControllers.contains {
            $0 is BannerErrorViewController ||
            ($0 as? UINavigationController)?.viewControllers.first is FullScreenErrorViewController
        }
    }

}
