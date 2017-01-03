//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct APIAccessToken {

    fileprivate static let keychainKeyPrefix = "APIAccessToken"
    fileprivate static let componentsSeparator = "."

    let clientId: String
    let useSandboxEnvironment: Bool

    var value: String?
    var key: String {
        let components = [APIAccessToken.keychainKeyPrefix,
                          clientId,
                          Options.Environment(useSandboxEnvironment: useSandboxEnvironment).rawValue]
        return components.joined(separator: APIAccessToken.componentsSeparator)
    }

    fileprivate init(config: Config, value: String? = nil) {
        self.clientId = config.clientId
        self.useSandboxEnvironment = config.useSandboxEnvironment
        self.value = value
    }

    fileprivate init?(key: String) {
        let components = key.components(separatedBy: ".")
        guard components.count == 3,
            components[0] == APIAccessToken.keychainKeyPrefix,
            let environment = Options.Environment(rawValue: components[2]) else {
                return nil
        }
        self.clientId = components[1]
        self.useSandboxEnvironment = environment.isSandbox
    }

}

extension APIAccessToken {

    @discardableResult
    static func store(token: String?, for config: Config) -> APIAccessToken? {
        let token = APIAccessToken(config: config, value: token)
        guard Keychain.writeToken(token) else { return nil }
        return token
    }

    static func retrieve(for config: Config) -> String? {
        return Keychain.readToken(for: config).value
    }

    @discardableResult
    static func delete(for config: Config) -> APIAccessToken {
        return Keychain.deleteToken(for: config)
    }

    @discardableResult
    static func wipe() -> [APIAccessToken] {
        return allKeys().flatMap {
            Keychain.deleteToken(withKey: $0)
        }
    }

    fileprivate static func allKeys() -> [String] {
        return Keychain.allAccounts().filter { account in
            account.hasPrefix(keychainKeyPrefix)
        }
    }

}

extension Keychain {

    @discardableResult
    fileprivate static func writeToken(_ token: APIAccessToken) -> Bool {
        guard let value = token.value else { return false }
        return (try? Keychain.write(value: value, forKey: token.key)) ?? false
    }

    fileprivate static func readToken(for config: Config) -> APIAccessToken {
        var token = APIAccessToken(config: config)
        token.value = Keychain.read(key: token.key)
        return token
    }

    @discardableResult
    fileprivate static func deleteToken(for config: Config) -> APIAccessToken {
        let token = APIAccessToken(config: config)
        return Keychain.delete(token: token)
    }

    @discardableResult
    fileprivate static func deleteToken(withKey key: String) -> APIAccessToken? {
        guard let token = APIAccessToken(key: key) else { return nil }
        return Keychain.delete(token: token)
    }

    @discardableResult
    fileprivate static func delete(token: APIAccessToken) -> APIAccessToken {
        Keychain.delete(key: token.key)
        return token
    }

}
