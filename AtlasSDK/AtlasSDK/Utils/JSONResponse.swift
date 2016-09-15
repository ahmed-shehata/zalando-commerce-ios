//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class JSONResponse {

    let statusCode: Int
    let httpHeaders: [String: String]?
    let body: JSON?

    init(statusCode: Int, httpHeaders: [String: String]?, body: JSON?) {
        self.statusCode = statusCode
        self.httpHeaders = httpHeaders
        self.body = body
    }

    convenience init(response: NSHTTPURLResponse, body: JSON?) {
        let httpHeaders = response.allHeaderFields as? [String: String]
        self.init(statusCode: response.statusCode, httpHeaders: httpHeaders, body: body)
    }

}
