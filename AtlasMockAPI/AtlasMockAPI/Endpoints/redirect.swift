//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addRedirectEndpoint() {
        let path = "/redirect"

        self[path] = { request in
            let redirectURL = request.queryParams.first(where: { key, _ in key == "url" })?.1 ?? ""
            return .movedPermanently(redirectURL.removingPercentEncoding ?? redirectURL)
        }
    }

}
