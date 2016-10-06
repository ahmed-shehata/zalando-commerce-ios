//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func process() -> T? {
        switch self {
        case .failure(let error):
            displayError(error)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType) {
        let viewController: AtlasUIViewController? = try? Atlas.provide()
        guard let userPresentable = error as? UserPresentable, atlasUIViewController = viewController else {
            UserMessage.unclassifiedError(error)
            return
        }

        switch userPresentable.errorPresentationType() {
        case .banner: displayBanner(userPresentable, atlasUIViewController: atlasUIViewController)
        case .fullScreen: displayFullScreen(userPresentable, atlasUIViewController: atlasUIViewController)
        }
    }

    private func displayBanner(error: UserPresentable, atlasUIViewController: AtlasUIViewController) {
        let bannerErrorViewController = atlasUIViewController.bannerErrorViewController
        atlasUIViewController.addChildViewController(bannerErrorViewController)
        atlasUIViewController.view.addSubview(bannerErrorViewController.view)
        bannerErrorViewController.view.fillInSuperView()
        bannerErrorViewController.configureData(error)
    }

    private func displayFullScreen(error: UserPresentable, atlasUIViewController: AtlasUIViewController) {
        let fullScreenErrorViewController = atlasUIViewController.fullScreenErrorViewController
        let navigationController = UINavigationController(rootViewController: fullScreenErrorViewController)
        atlasUIViewController.addChildViewController(navigationController)
        atlasUIViewController.view.addSubview(navigationController.view)
        navigationController.view.fillInSuperView()
        fullScreenErrorViewController.configureData(error)
    }

}
