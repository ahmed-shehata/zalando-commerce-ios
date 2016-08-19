//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURLComponents {

    convenience init(validUrlString urlString: String) {
        self.init(string: urlString)! // swiftlint:disable:this force_unwrapping
    }

    convenience init(validURL url: NSURL) {
        self.init(URL: url, resolvingAgainstBaseURL: false)! // swiftlint:disable:this force_unwrapping
    }

    var validURL: NSURL {
        return self.URL! // swiftlint:disable:this force_unwrapping
    }

}
