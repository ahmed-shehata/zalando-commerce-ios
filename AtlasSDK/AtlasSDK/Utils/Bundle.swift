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
        let identifier = self.string(for: "CFBundleIdentifier") ?? "<UNKNOWN>"
        let shortVersion = self.string(for: "CFBundleShortVersionString") ?? "<UNKNOWN>"
        let bundleVersion = self.string(for: "CFBundleVersion") ?? "<UNKNOWN>"

        let version = shortVersion == bundleVersion ? shortVersion : "\(shortVersion) (\(bundleVersion))"

        return "\(identifier) \(version)"
    }

}
