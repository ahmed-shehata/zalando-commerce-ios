//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class ReachabilityNotifier {

    fileprivate var reachability: Reachability?

    func start() {
        guard let reachability = Reachability(), !UIApplication.unitTestsAreRunning else { return }

        reachability.whenReachable = { _ in
            Async.main {
                UserError.hideBannerError()
            }
        }

        reachability.whenUnreachable = { _ in
            Async.main {
                UserError.display(error: APIError.noInternet)
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
