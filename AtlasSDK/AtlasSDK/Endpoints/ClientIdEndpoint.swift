//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol ClientIdEndpoint: SalesChannelEndpoint {

    var clientId: String { get }

}

extension ClientIdEndpoint {

    var headers: EndpointHeaders? {
        return ["X-UID": clientId, "X-Sales-Channel": salesChannel]
    }

}
