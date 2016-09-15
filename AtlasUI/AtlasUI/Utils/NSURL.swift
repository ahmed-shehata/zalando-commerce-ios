//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURL {

    var validAbsoluteString: String {
        #if swift(>=2.3)
            return self.absoluteString! // swiftlint:disable:this force_unwrapping
        #else
            return self.absoluteString
        #endif

    }

}

extension NSURL {

    enum QueryItemKey: String {
        case accessToken = "access_token"
        case error = "error"
    }

    enum QueryItemValue: String {
        case accessDenied = "access_denied"
    }


    var accessToken: String? {
        return queryItemValue(.accessToken) ?? fragmentValue(.accessToken)
    }

    var isAccessDenied: Bool {
        return hasQueryItem(.error, value: .accessDenied)
    }

    func queryItemValue(key: QueryItemKey) -> String? {
        let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue }.last
        return queryAccessToken?.value
    }

    func hasQueryItem(key: QueryItemKey, value: QueryItemValue? = nil) -> Bool {
        return hasQueryItem(key, value: value?.rawValue)
    }

    func hasQueryItem(key: QueryItemKey, value: String? = nil) -> Bool {
        let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue && (value == nil || $0.value == value) }.last
        return queryAccessToken != nil
    }

    func fragmentValue(key: QueryItemKey) -> String? {
        guard let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false),
            fragment = urlComponents.fragment else { return nil }

        urlComponents.query = fragment
        return urlComponents.URL?.queryItemValue(key)
    }

}

