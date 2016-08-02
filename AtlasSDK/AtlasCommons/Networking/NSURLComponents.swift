//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension NSURLComponents {

    public convenience init(validUrlString urlString: String) {
        self.init(string: urlString)! // swiftlint:disable:this force_unwrapping
    }

    public convenience init(validURL url: NSURL) {
        self.init(URL: url, resolvingAgainstBaseURL: false)! // swiftlint:disable:this force_unwrapping
    }

    public var validURL: NSURL {
        return self.URL! // swiftlint:disable:this force_unwrapping
    }

}
