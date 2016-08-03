//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension String {

    init?(contentsOfFile url: NSURL, encoding: NSStringEncoding = NSUTF8StringEncoding) {
        guard let data = NSData(contentsOfURL: url) else { return nil }
        let contents = NSString(data: data, encoding: encoding)
        self.init(contents)
    }

}
