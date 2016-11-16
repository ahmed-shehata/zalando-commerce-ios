//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addRedirectEndpoint() {
        let path = "/redirect"

        self[path] = { request in
            let redirectURL = request.queryParams.filter({ (key, val) in key == "url" }).first?.1 ?? ""
            return .movedPermanently(redirectURL.removingPercentEncoding ?? redirectURL)
        }
    }

}
