//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

    var isSuccessful: Bool {
        return status.isSuccessful
    }

    var status: HTTPStatus {
        return HTTPStatus(statusCode: self.statusCode)
    }

    convenience init?(url: URL, statusCode: Int) {
        self.init(url: url, statusCode: statusCode, httpVersion: "1.1", headerFields: nil)
    }

}
