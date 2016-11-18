//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Security

struct Keychain {

    @discardableResult
    static func delete(key: String) -> Bool {
        return write(value: nil, forKey: key)
    }

    @discardableResult
    static func write(value: String?, forKey key: String) -> Bool {
        var status: OSStatus
        defer {
            if status != errSecSuccess {
                AtlasLogger.logError("Error saving in Keychain:", status.description)
            }
        }

        let query = prepareItemQuery(key)

        guard let value = value, let data = value.data(using: String.Encoding.utf8) else {
            status = SecItemDelete(query as CFDictionary)
            return status == errSecSuccess
        }

        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            let updateData: [AnyHashable: Any] = [kSecValueData as AnyHashable: data]
            status = SecItemUpdate(query as CFDictionary, updateData as CFDictionary)
        } else {
            var securedItem = query
            securedItem[kSecValueData as AnyHashable] = data
            status = SecItemAdd(securedItem as CFDictionary, nil)
        }

        return status == errSecSuccess
    }

    static func read(forKey key: String) -> String? {
        var query = prepareItemQuery(key)
        query[kSecReturnData as AnyHashable] = true
        query[kSecReturnAttributes as AnyHashable] = true

        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard let resultDict = result as? [NSString: AnyObject],
            let resultData = resultDict[kSecValueData] as? Data, status == errSecSuccess else {
                return nil
        }

        return String(data: resultData, encoding: String.Encoding.utf8)
    }

    fileprivate static func prepareItemQuery(_ account: String) -> [AnyHashable: Any] {
        return [kSecClass as AnyHashable: kSecClassGenericPassword,
            kSecAttrAccessible as AnyHashable: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccount as AnyHashable: account,
            kSecAttrService as AnyHashable: Bundle.main.bundleIdentifier ?? "de.zalando.AtlasSDK"]
    }

}

extension OSStatus {

    var description: String {
        switch self {
        case errSecSuccess:
            return addStatus(to: "OK.")
        case errSecUnimplemented:
            return addStatus(to: "Function or operation not implemented.")
        case errSecParam:
            return addStatus(to: "One or more parameters passed to a function where not valid.")
        case errSecAllocate:
            return addStatus(to: "Failed to allocate memory.")
        case errSecNotAvailable:
            return addStatus(to: "No keychain is available. You may need to restart your computer.")
        case errSecDuplicateItem:
            return addStatus(to: "The specified item already exists in the keychain.")
        case errSecItemNotFound:
            return addStatus(to: "The specified item could not be found in the keychain.")
        case errSecInteractionNotAllowed:
            return addStatus(to: "User interaction is not allowed.")
        case errSecDecode:
            return addStatus(to: "Unable to decode the provided data.")
        case errSecAuthFailed:
            return addStatus(to: "The user name or passphrase you entered is not correct.")
        default:
            return addStatus(to: "Refer to SecBase.h for description")
        }
    }

    fileprivate func addStatus(to message: String) -> String {
        return message + " (status: \(self))"
    }

}
