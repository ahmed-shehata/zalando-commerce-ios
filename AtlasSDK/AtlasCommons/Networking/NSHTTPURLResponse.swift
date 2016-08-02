//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSHTTPURLResponse {

    public var isSuccessful: Bool {
        return (200..<400).contains(self.statusCode)
    }

    public convenience init?(URL: NSURL, statusCode: Int) {
        self.init(URL: URL, statusCode: statusCode, HTTPVersion: "1.1", headerFields: nil)
    }

}
