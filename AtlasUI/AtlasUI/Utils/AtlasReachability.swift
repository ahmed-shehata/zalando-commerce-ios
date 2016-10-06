//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasReachability {

    private var reachability: AtlasUI_Reachability?

    internal func setupReachability() {
        let viewController: AtlasUIViewController? = try? Atlas.provide()
        guard let atlasUIViewController = viewController else { return }

        do {
            reachability = try AtlasUI_Reachability.reachabilityForInternetConnection()
            try reachability?.startNotifier()
        } catch {
            AtlasLogger.logError("Reachability Configuration error")
        }

        reachability?.whenReachable = { [weak self] _ in
            Async.main {
                self?.removeReachabilityBanner(atlasUIViewController)
            }
        }

        reachability?.whenUnreachable = { [weak self] _ in
            Async.main {
                self?.displayReachabilityBanner(atlasUIViewController)
            }
        }
    }

    private func displayReachabilityBanner(atlasUIViewController: AtlasUIViewController) {
        atlasUIViewController.addChildViewController(atlasUIViewController.bannerErrorViewController)
        atlasUIViewController.view.addSubview(atlasUIViewController.bannerErrorViewController.view)
        atlasUIViewController.bannerErrorViewController.view.fillInSuperView()
        atlasUIViewController.bannerErrorViewController.configureData(ReachabilityUserPresentableError())
    }

    private func removeReachabilityBanner(atlasUIViewController: AtlasUIViewController) {
        atlasUIViewController.bannerErrorViewController.hideBanner()
    }

}
