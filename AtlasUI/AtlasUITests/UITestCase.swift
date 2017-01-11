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
        let errorPresenterViewController = atlasUIViewController?.presentedViewController ?? atlasUIViewController
        let errorViewControllers = errorPresenterViewController?.childViewControllers.flatMap { ($0 as? BannerErrorViewController) ?? (($0 as? UINavigationController)?.viewControllers.first as? FullScreenErrorViewController) } ?? []
        return !errorViewControllers.isEmpty
    }

}
