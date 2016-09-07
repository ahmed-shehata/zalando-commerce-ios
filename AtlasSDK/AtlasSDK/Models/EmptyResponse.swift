//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct EmptyResponse {

}

extension EmptyResponse: JSONInitializable {

    init?(json: JSON) {
    }

}
