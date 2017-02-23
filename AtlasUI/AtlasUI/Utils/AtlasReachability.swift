//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

// TODO: Check: Remove "Atlas" from name

class AtlasReachability {

    fileprivate var reachability: Reachability?

    func setupReachability() {
        guard let reachability = Reachability(), !UIApplication.unitTestsAreRunning else { return }

        reachability.whenReachable = { _ in
            Async.main {
                UserError.hideBannerError()
            }
        }

        reachability.whenUnreachable = { _ in
            Async.main {
                UserError.display(error: AtlasAPIError.noInternet)
            }
        }

        do {
            try reachability.startNotifier()
        } catch let error {
            Logger.error(error)
            return
        }

        self.reachability = reachability
    }

}
