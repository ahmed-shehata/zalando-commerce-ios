//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIAccessToken {

    private static let keychainKey = "APIAccessToken"

    public static func store(newToken: String?) {
        Keychain.write(newToken, forKey: keychainKey)
    }

    public static func retrieve() -> String? {
        return Keychain.read(forKey: keychainKey)
    }

    public static func delete() {
        Keychain.delete(key: keychainKey)
    }

    private init() { }

}
