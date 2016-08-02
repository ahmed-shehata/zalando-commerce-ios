//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

struct APIAccessToken {

    private static let keychainKey = "APIAccessToken"

    static func store(newToken: String?) {
        Keychain.write(newToken, forKey: keychainKey)
    }

    static func retrieve() -> String? {
        return Keychain.read(forKey: keychainKey)
    }

    static func delete() {
        Keychain.delete(key: keychainKey)
    }

    private init() { }

}
