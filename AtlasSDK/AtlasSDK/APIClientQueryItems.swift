//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension APIClient {

    enum QueryItemKey: String {
        case accessToken = "access_token"
        case error = "error"
    }

    enum QueryItemValue: String {
        case accessDenied = "access_denied"
    }

}

extension NSURL {

    var accessToken: String? {
        return queryItemValue(.accessToken) ?? fragmentValue(.accessToken)
    }

    var isAccessDenied: Bool {
        return hasQueryItem(.error, value: .accessDenied)
    }

    func queryItemValue(key: APIClient.QueryItemKey) -> String? {
        let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue }.last
        return queryAccessToken?.value
    }

    func hasQueryItem(key: APIClient.QueryItemKey, value: APIClient.QueryItemValue? = nil) -> Bool {
        return hasQueryItem(key, value: value?.rawValue)
    }

    func hasQueryItem(key: APIClient.QueryItemKey, value: String? = nil) -> Bool {
        let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue && (value == nil || $0.value == value) }.last
        return queryAccessToken != nil
    }

    func fragmentValue(key: APIClient.QueryItemKey) -> String? {
        guard let urlComponents = NSURLComponents(URL: self, resolvingAgainstBaseURL: false),
            fragment = urlComponents.fragment else { return nil }

        urlComponents.query = fragment
        return urlComponents.URL?.queryItemValue(key)
    }

}

extension NSURLQueryItem {

    convenience init(key: APIClient.QueryItemKey, value: String) {
        self.init(name: key.rawValue, value: value)
    }

    convenience init(key: APIClient.QueryItemKey, value: APIClient.QueryItemValue) {
        self.init(name: key.rawValue, value: value.rawValue)
    }

}
