//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Bundle {

    func version(prefix: String? = nil) -> String {
        let identifier = prefix ?? self.string(for: "CFBundleIdentifier")
        let version = self.string(for: "CFBundleShortVersionString")
        let build = self.string(for: "CFBundleVersion")

        return "\(identifier~?) \(version~?) (\(build~?))"
    }

}
