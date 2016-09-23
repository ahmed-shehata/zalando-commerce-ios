//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct GetConfigEndpoint: Endpoint {

    let URL: NSURL
    var isOAuth: Bool {
        return false
    }
}
