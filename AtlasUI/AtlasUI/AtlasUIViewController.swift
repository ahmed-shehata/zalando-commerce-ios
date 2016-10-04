//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

public class AtlasUIViewController: UIViewController {

    let mainNavigationController: UINavigationController
    private var reachability: Reachability?
    private let reachabilityErrorViewController = BannerErrorViewController()

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

        reachability?.whenReachable = { [weak self ]_ in
            self?.removeBanner()
        }

        reachability?.whenUnreachable = { [weak self ]_ in
            self?.displayBanner()
        }
    }

    private func displayBanner() {
        addChildViewController(reachabilityErrorViewController)
        view.addSubview(reachabilityErrorViewController.view)
        reachabilityErrorViewController.view.fillInSuperView()
        reachabilityErrorViewController.configureData(ReachabilityUserPresentableError())
    }

    private func removeBanner() {
        reachabilityErrorViewController.hideBanner()
    }

}
