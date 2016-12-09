//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias ButtonActionHandler = ((UIAlertAction) -> Void)

struct ButtonAction {

    let text: String
    let handler: ButtonActionHandler?
    let style: UIAlertActionStyle

    init(text: String, style: UIAlertActionStyle = .default, handler: ButtonActionHandler? = nil) {
        self.text = text
        self.handler = handler
        self.style = style
    }

}

struct UserMessage {

    fileprivate static let bannerErrorViewController = BannerErrorViewController()
    fileprivate static let fullScreenErrorViewController = FullScreenErrorViewController()

    static var errorDisplayed: Bool {
        return bannerErrorViewController.parent != nil || fullScreenErrorViewController.navigationController?.parent != nil
    }

    static func hideBannerError() {
        bannerErrorViewController.dismiss()
    }

    static func loadBannerError() {
        bannerErrorViewController.view.alpha = 0
        UIApplication.shared.keyWindow?.insertSubview(bannerErrorViewController.view, at: 0)
        bannerErrorViewController.view.fillInSuperview()
        bannerErrorViewController.configure(viewModel: AtlasCheckoutError.unclassified)
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

    static func displayError(error: Error) {
        guard let userPresentable = error as? UserPresentableError else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        switch userPresentable.presentationMode {
        case .banner: displayBanner(error: userPresentable)
        case .fullScreen: displayFullScreen(error: userPresentable)
        }
    }

    static func displayErrorBanner(error: Error) {
        guard let userPresentable = error as? UserPresentableError else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        displayBanner(error: userPresentable)
    }

    static func displayErrorFullScreen(error: Error) {
        guard let userPresentable = error as? UserPresentableError else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        displayFullScreen(error: userPresentable)
    }

    static func presentSelection(title: String?, message: String? = nil, actions: [ButtonAction]) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actions.forEach { alertView.add(button: $0) }

        Async.main {
            topViewController.present(alertView, animated: true, completion: nil)
        }
    }

    static func displayLoader(block: (@escaping () -> Void) -> Void) {
        AtlasUIViewController.shared?.showLoader()
        block {
            AtlasUIViewController.shared?.hideLoader()
        }
    }

}

extension UserMessage {

    fileprivate static var errorPresenterViewController: UIViewController? {
        guard let atlasUIViewController = AtlasUIViewController.shared else { return nil }
        return atlasUIViewController.presentedViewController ?? atlasUIViewController
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

extension UIAlertController {

    fileprivate func add(button: ButtonAction) {
        let title = Localizer.format(string: button.text)
        let action = UIAlertAction(title: title, style: button.style, handler: button.handler)
        self.addAction(action)
    }

}
