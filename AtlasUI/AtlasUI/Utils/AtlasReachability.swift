//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasReachability {

    fileprivate var reachability: Reachability?

    func setupReachability() {
        guard let reachability = Reachability(), !UIApplication.unitTestsAreRunning else { return }

        reachability.whenReachable = { _ in
            Async.main {
                UserMessage.hideBannerError()
            }
        }

        reachability.whenUnreachable = { _ in
            Async.main {
                UserMessage.displayError(error: AtlasAPIError.noInternet)
            }
        }

        do {
            try reachability.startNotifier()
        } catch let error {
            AtlasLogger.logError(error)
            return
        }

        self.reachability = reachability
    }

}
