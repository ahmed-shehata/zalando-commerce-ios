//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSError {

    convenience init(atlasError: AtlasError) {
        var userInfo: [String: String]? = nil
        if let details = atlasError.extraDetails {
            userInfo = [NSLocalizedDescriptionKey: details]
        }
        self.init(domain: AtlasError.ErrorDomain, code: atlasError.code, userInfo: userInfo)
    }

}
