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
            // TODO: Need to check for network errors
            UserMessage.unclasifiedError(error)
            return
        }

        switch userPresentable.errorPresentationType() {
        case .banner: displayBanner(userPresentable, atlasUIViewController: atlasUIViewController)
        case .fullScreen: displayFullScreen(userPresentable, atlasUIViewController: atlasUIViewController)
        }
    }

    private func displayBanner(error: UserPresentable, atlasUIViewController: AtlasUIViewController) {
        // TODO: Show Banner
        UserMessage.show(error: error)
    }

    private func displayFullScreen(error: UserPresentable, atlasUIViewController: AtlasUIViewController) {
        let fullScreenErrorViewController = FullScreenErrorViewController()
        let navigationController = UINavigationController(rootViewController: fullScreenErrorViewController)
        atlasUIViewController.addChildViewController(navigationController)
        atlasUIViewController.view.addSubview(navigationController.view)
        navigationController.view.fillInSuperView()
        fullScreenErrorViewController.configureData(error)
    }

}
