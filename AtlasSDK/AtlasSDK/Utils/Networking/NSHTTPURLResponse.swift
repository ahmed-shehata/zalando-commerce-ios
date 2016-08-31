//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSHTTPURLResponse {

    var isSuccessful: Bool {
        return status.isSuccessful
    }

    var status: HTTPStatus {
        return HTTPStatus(statusCode: self.statusCode)
    }

    convenience init?(URL: NSURL, statusCode: Int) {
        self.init(URL: URL, statusCode: statusCode, HTTPVersion: "1.1", headerFields: nil)
    }

}
