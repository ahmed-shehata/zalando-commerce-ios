//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Bundle {

    func string(for key: String) -> String? {
        return self.object(forInfoDictionaryKey: key)
    }

    func object<T>(forInfoDictionaryKey key: String) -> T? {
        return self.object(forInfoDictionaryKey: key) as? T
    }

    var version: String {
        let identifier = self.string(for: "CFBundleIdentifier")
        let version = self.string(for: "CFBundleShortVersionString")
        let build = self.string(for: "CFBundleVersion")

        return "\(identifier~?) \(version~?) (\(build~?))"
    }

}
