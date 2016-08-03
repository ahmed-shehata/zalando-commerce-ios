//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Security

struct Keychain {

    static func delete(key key: String) -> Bool {
        return write(nil, forKey: key)
    }

    static func write(value: String?, forKey key: String) -> Bool {
        var status: OSStatus
        defer {
            if status != errSecSuccess {
                AtlasLogger.logError("Error saving in Keychain:", status.description)
            }
        }

        let query = prepareItemQuery(key)

        guard let value = value, data = value.dataUsingEncoding(NSUTF8StringEncoding) else {
            status = SecItemDelete(query)
            return status == errSecSuccess
        }

        if SecItemCopyMatching(query, nil) == errSecSuccess {
            let updateData: [NSObject: AnyObject] = [kSecValueData: data]
            status = SecItemUpdate(query, updateData)
        } else {
            var securedItem = query
            securedItem[kSecValueData] = data
            status = SecItemAdd(securedItem, nil)
        }

        return status == errSecSuccess
    }

    static func read(forKey key: String) -> String? {
        var query = prepareItemQuery(key)
        query[kSecReturnData] = true
        query[kSecReturnAttributes] = true

        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(query, UnsafeMutablePointer($0))
        }

        guard let resultDict = result as? [NSString: AnyObject],
            resultData = resultDict[kSecValueData] as? NSData where status == errSecSuccess else {
                return nil
        }

        return String(data: resultData, encoding: NSUTF8StringEncoding)
    }

    private static func prepareItemQuery(account: String) -> [NSObject: AnyObject] {
        return [kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked,
            kSecAttrAccount: account,
            kSecAttrService: NSBundle.mainBundle().bundleIdentifier ?? "de.zalando.AtlasSDK"]
    }

}

extension OSStatus {

    var description: String {
        switch self {
        case errSecSuccess:
            return addStatus("OK.")
        case errSecUnimplemented:
            return addStatus("Function or operation not implemented.")
        case errSecParam:
            return addStatus("One or more parameters passed to a function where not valid.")
        case errSecAllocate:
            return addStatus("Failed to allocate memory.")
        case errSecNotAvailable:
            return addStatus("No keychain is available. You may need to restart your computer.")
        case errSecDuplicateItem:
            return addStatus("The specified item already exists in the keychain.")
        case errSecItemNotFound:
            return addStatus("The specified item could not be found in the keychain.")
        case errSecInteractionNotAllowed:
            return addStatus("User interaction is not allowed.")
        case errSecDecode:
            return addStatus("Unable to decode the provided data.")
        case errSecAuthFailed:
            return addStatus("The user name or passphrase you entered is not correct.")
        default:
            return addStatus("Refer to SecBase.h for description")
        }
    }

    private func addStatus(message: String) -> String {
        return message + " (status: \(self))"
    }

}
