//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSHTTPURLResponse {

    var isSuccessful: Bool {
        return HTTPStatus(statusCode: self.statusCode).isSuccessful
    }

    convenience init?(URL: NSURL, statusCode: Int) {
        self.init(URL: URL, statusCode: statusCode, HTTPVersion: "1.1", headerFields: nil)
    }

}
