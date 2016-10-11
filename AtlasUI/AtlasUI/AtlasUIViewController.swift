//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

public class AtlasUIViewController: UIViewController {

    let mainNavigationController: UINavigationController
    private let bannerErrorViewController = BannerErrorViewController()
    private let fullScreenErrorViewController = FullScreenErrorViewController()
    private let atlasReachability = AtlasReachability()

    init(atlasCheckout: AtlasCheckout, forProductSKU sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(checkout: atlasCheckout, sku: sku)
        mainNavigationController = UINavigationController(rootViewController: sizeSelectionViewController)

        super.init(nibName: nil, bundle: nil)
    }

    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.fillInSuperView()
        atlasReachability.setupReachability()
    }

}

extension AtlasUIViewController {

    var errorDisplayed: Bool {
        return bannerErrorViewController.parentViewController != nil || fullScreenErrorViewController.parentViewController != nil
    }

    internal func displayError(error: UserPresentable) {
        switch error.errorPresentationType() {
        case .banner: displayBanner(error)
        case .fullScreen: displayFullScreen(error)
        }
    }

    internal func clearBannerError() {
        bannerErrorViewController.hideBanner()
    }

    private func displayBanner(error: UserPresentable) {
        addChildViewController(bannerErrorViewController)
        view.addSubview(bannerErrorViewController.view)
        bannerErrorViewController.view.fillInSuperView()
        bannerErrorViewController.configureData(error)
    }

    private func displayFullScreen(error: UserPresentable) {
        let navigationController = UINavigationController(rootViewController: fullScreenErrorViewController)
        addChildViewController(navigationController)
        view.addSubview(navigationController.view)
        navigationController.view.fillInSuperView()
        fullScreenErrorViewController.configureData(error)
    }

}
