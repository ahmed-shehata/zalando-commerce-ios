//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URL {

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

    func queryItemValue(_ key: QueryItemKey) -> String? {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue }.last
        return queryAccessToken?.value
    }

    func hasQueryItem(_ key: QueryItemKey, value: QueryItemValue? = nil) -> Bool {
        return hasQueryItem(key, value: value?.rawValue)
    }

    func hasQueryItem(_ key: QueryItemKey, value: String? = nil) -> Bool {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue && (value == nil || $0.value == value) }.last
        return queryAccessToken != nil
    }

    func fragmentValue(_ key: QueryItemKey) -> String? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let fragment = urlComponents.fragment else { return nil }

        urlComponents.query = fragment
        return urlComponents.url?.queryItemValue(key)
    }

}
