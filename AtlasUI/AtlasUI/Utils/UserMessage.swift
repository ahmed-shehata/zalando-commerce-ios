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

    private static let bannerErrorViewController = BannerErrorViewController()
    private static let fullScreenErrorViewController = FullScreenErrorViewController()

    static var errorDisplayed: Bool {
        return bannerErrorViewController.parent != nil || fullScreenErrorViewController.parent != nil
    }

    static func hideBannerError() {
        bannerErrorViewController.hideBanner()
    }

    static func hideError() {
        bannerErrorViewController.hideBanner() {
            fullScreenErrorViewController.view.removeFromSuperview()
            fullScreenErrorViewController.removeFromParentViewController()
        }
    }

    static func displayError(error: Error) {
        guard let userPresentable = error as? UserPresentable else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        switch userPresentable.errorPresentationType() {
        case .banner: displayBanner(userPresentable)
        case .fullScreen: displayFullScreen(userPresentable)
        }
    }

    static func displayErrorBanner(error: Error) {
        guard let userPresentable = error as? UserPresentable else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        displayBanner(userPresentable)
    }

    static func displayErrorFullScreen(error: Error) {
        guard let userPresentable = error as? UserPresentable else {
            displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        displayFullScreen(userPresentable)
    }

    static func showActionSheet(title: String?, message: String? = nil, actions: ButtonAction...) {
        showActionSheet(title: title, message: message, actions: actions)
    }

    static func showActionSheet(title: String?, message: String? = nil, actions: [ButtonAction]) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actions.forEach { alertView.addAction($0) }

        Async.main {
            topViewController.present(alertView, animated: true, completion: nil)
        }
    }

    static func displayLoader(block: (() -> Void) -> Void) {
        AtlasUIViewController.shared?.showLoader()
        block {
            AtlasUIViewController.shared?.hideLoader()
        }
    }

}

extension UserMessage {

    private static var errorPresenterViewController: UIViewController? {
        let viewController: AtlasUIViewController? = try? AtlasUI.provide()
        guard let atlasUIViewController = viewController else { return nil }
        return atlasUIViewController.presentedViewController ?? atlasUIViewController
    }

    private static func displayBanner(error: UserPresentable) {
        guard let viewController = errorPresenterViewController else { return }
        bannerErrorViewController.removeFromParentViewController()
        bannerErrorViewController.view.removeFromSuperview()

        viewController.addChildViewController(bannerErrorViewController)
        viewController.view.addSubview(bannerErrorViewController.view)

        bannerErrorViewController.view.fillInSuperView()
        bannerErrorViewController.configureData(error)
    }

    private static func displayFullScreen(error: UserPresentable) {
        guard let viewController = errorPresenterViewController else { return }
        let navigationController = UINavigationController(rootViewController: fullScreenErrorViewController)

        viewController.addChildViewController(navigationController)
        viewController.view.addSubview(navigationController.view)

        navigationController.view.fillInSuperView()
        fullScreenErrorViewController.configureData(error)
    }

}

private extension UIAlertController {

    func addAction(button: ButtonAction) {
        let title = Localizer.string(button.text)
        let action = UIAlertAction(title: title, style: button.style, handler: button.handler)
        self.addAction(action)
    }

}
