//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import ZalandoCommerceAPI

struct UserError {

    fileprivate static let bannerErrorViewController = BannerErrorViewController()
    fileprivate static let fullScreenErrorViewController = FullScreenErrorViewController()

    static func hideBannerError() {
        bannerErrorViewController.dismiss()
    }

    static func loadBannerError() {
        bannerErrorViewController.view.alpha = 0
        UIApplication.shared.keyWindow?.insertSubview(bannerErrorViewController.view, at: 0)
        bannerErrorViewController.view.fillInSuperview()
        bannerErrorViewController.configure(viewModel: CheckoutError.unclassified)
        UIView.waitForUIState {
            bannerErrorViewController.view.removeFromSuperview()
        }
    }

    static func resetBanners() {
        bannerErrorViewController.view.removeFromSuperview()
        bannerErrorViewController.removeFromParentViewController()
        fullScreenErrorViewController.navigationController?.view.removeFromSuperview()
        fullScreenErrorViewController.navigationController?.removeFromParentViewController()
    }

    static func display(error: Error, mode: PresentationMode? = nil) {
        guard let userPresentable = error as? UserPresentableError else {
            UserError.display(error: CheckoutError.unclassified)
            return
        }

        let mode = mode ?? userPresentable.presentationMode

        switch mode {
        case .banner: displayBanner(error: userPresentable)
        case .fullScreen: displayFullScreen(error: userPresentable)
        }
    }

}

extension UserError {

    fileprivate static var errorPresenterViewController: UIViewController? {
        guard let zCommerceUIViewController = ZalandoCommerceUIViewController.presented else { return nil }
        return zCommerceUIViewController.presentedViewController ?? zCommerceUIViewController
    }

    fileprivate static func displayBanner(error: UserPresentableError) {
        guard let viewController = errorPresenterViewController else { return }
        bannerErrorViewController.removeFromParentViewController()
        bannerErrorViewController.view.removeFromSuperview()

        viewController.addChildViewController(bannerErrorViewController)
        viewController.view.addSubview(bannerErrorViewController.view)

        bannerErrorViewController.view.fillInSuperview()
        bannerErrorViewController.configure(viewModel: error)
    }

    fileprivate static func displayFullScreen(error: UserPresentableError) {
        guard let viewController = errorPresenterViewController else { return }
        let navigationController = UINavigationController(rootViewController: fullScreenErrorViewController)

        viewController.addChildViewController(navigationController)
        viewController.view.addSubview(navigationController.view)

        navigationController.view.fillInSuperview()
        fullScreenErrorViewController.configure(viewModel: error)
    }

}
