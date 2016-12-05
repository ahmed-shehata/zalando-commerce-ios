//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasReachability {

    private var reachability: AtlasUI_Reachability?

    func setupReachability() {
        do {
            reachability = try AtlasUI_Reachability.reachabilityForInternetConnection()
            try reachability?.startNotifier()
        } catch let error {
            AtlasLogger.logError(error)
        }

        reachability?.whenReachable = { _ in
            Async.main {
                UserMessage.hideBannerError()
            }
        }

        reachability?.whenUnreachable = { _ in
            Async.main {
                UserMessage.displayError(AtlasAPIError.noInternet)
            }
        }
    }

}
