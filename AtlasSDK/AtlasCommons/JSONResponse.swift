//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public class JSONResponse {

    public let statusCode: Int
    public let httpHeaders: [String: String]?
    public let body: JSON

    public init(statusCode: Int, httpHeaders: [String: String]?, body: JSON) {
        self.statusCode = statusCode
        self.httpHeaders = httpHeaders
        self.body = body
    }

    public convenience init(response: NSHTTPURLResponse, body: JSON) {
        let httpHeaders = response.allHeaderFields as? [String: String]
        self.init(statusCode: response.statusCode, httpHeaders: httpHeaders, body: body)
    }

}
