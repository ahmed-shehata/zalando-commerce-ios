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

    init(text: String, style: UIAlertActionStyle = .Default, handler: ButtonActionHandler? = nil) {
        self.text = text
        self.handler = handler
        self.style = style
    }

}

struct UserMessage {

    private static let bannerErrorViewController = BannerErrorViewController()
    private static let fullScreenErrorViewController = FullScreenErrorViewController()

    static var errorDisplayed: Bool {
        return bannerErrorViewController.parentViewController != nil || fullScreenErrorViewController.parentViewController != nil
    }

    static func clearBannerError() {
        bannerErrorViewController.hideBanner()
    }

    static func displayError(error: ErrorType) {
        let viewController: AtlasUIViewController? = try? Atlas.provide()
        guard let userPresentable = error as? UserPresentable, atlasUIViewController = viewController else {
            displayError(AtlasCatalogError.unclassified)
            return
        }

        switch userPresentable.errorPresentationType() {
        case .banner: displayBanner(userPresentable, on: atlasUIViewController)
        case .fullScreen: displayFullScreen(userPresentable, on: atlasUIViewController)
        }
    }

    static func showActionSheet(title title: String, message: String? = nil, actions: ButtonAction...) {
            guard let topViewController = UIApplication.topViewController() else { return }
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

            actions.forEach { alertView.addAction($0) }

            Async.main {
                topViewController.presentViewController(alertView, animated: true, completion: nil)
            }
    }

    private static func displayBanner(error: UserPresentable, on viewController: UIViewController) {
        bannerErrorViewController.removeFromParentViewController()
        bannerErrorViewController.view.removeFromSuperview()

        viewController.addChildViewController(bannerErrorViewController)
        viewController.view.addSubview(bannerErrorViewController.view)

        bannerErrorViewController.view.fillInSuperView()
        bannerErrorViewController.configureData(error)
    }

    private static func displayFullScreen(error: UserPresentable, on viewController: UIViewController) {
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
