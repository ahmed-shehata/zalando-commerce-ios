//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

public class AtlasUIViewController: UIViewController {

    let mainNavigationController: UINavigationController
    var reachability: Reachability?

    init(atlasCheckout: AtlasCheckout, forProductSKU sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(checkout: atlasCheckout, sku: sku)
        mainNavigationController = UINavigationController(rootViewController: sizeSelectionViewController)

        super.init(nibName: nil, bundle: nil)
        setupReachability()
    }

    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        reachability?.stopNotifier()
        reachability = nil
    }

    override public func viewDidLoad() {
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.fillInSuperView()
    }

}

extension AtlasUIViewController {

    func setupReachability() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            try reachability?.startNotifier()
        } catch {
            AtlasLogger.logError("Reachability Configuration error")
        }
    }

    private func displayBanner(error: UserPresentable) {
        let bannerErrorViewController = BannerErrorViewController()
        addChildViewController(bannerErrorViewController)
        view.addSubview(bannerErrorViewController.view)
        bannerErrorViewController.view.fillInSuperView()
        bannerErrorViewController.configureData(error)
    }

}

struct ReachabilityUserPresentableError: UserPresentable {

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.title")
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.message")
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }
}
