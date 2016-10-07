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

        reachability?.whenReachable = { _ in
            Async.main {
                atlasUIViewController.clearBannerError()
            }
        }

        reachability?.whenUnreachable = { _ in
            Async.main {
                atlasUIViewController.displayError(AtlasAPIError.noInternet)
            }
        }
    }

}
