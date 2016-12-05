//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct APIAccessToken {

    fileprivate static let keychainKey = "APIAccessToken"

    static func store(token: String?) {
        Keychain.write(value: token, forKey: keychainKey)
    }

    static func retrieve() -> String? {
        return Keychain.read(forKey: keychainKey)
    }

    static func delete() {
        Keychain.delete(key: keychainKey)
    }

    fileprivate init() { }

}
