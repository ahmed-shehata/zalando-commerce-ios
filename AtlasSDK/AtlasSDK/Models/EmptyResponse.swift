//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

@available( *, deprecated, message = "APIClient should not try deserialize empty response")
public struct EmptyResponse {

}

extension EmptyResponse: JSONInitializable {

    init?(json: JSON) {
    }

}
