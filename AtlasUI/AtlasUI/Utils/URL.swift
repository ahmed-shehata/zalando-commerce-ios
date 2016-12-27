//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URL {

    func removeCookies(from storage: HTTPCookieStorage = HTTPCookieStorage.shared) {
        storage.cookies(for: self)?.forEach { cookie in
            storage.deleteCookie(cookie)
        }
    }

}

extension URL {

    enum QueryItemKey: String {
        case accessToken = "access_token"
        case error = "error"
    }

    enum QueryItemValue: String {
        case accessDenied = "access_denied"
    }

    var accessToken: String? {
        return queryItemValue(for: .accessToken) ?? fragmentValue(for: .accessToken)
    }

    var isAccessDenied: Bool {
        return hasQueryItem(with: .error, value: .accessDenied)
    }

    private func queryItemValue(for key: QueryItemKey) -> String? {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue }.last
        return queryAccessToken?.value
    }

    private func hasQueryItem(with key: QueryItemKey, value: QueryItemValue? = nil) -> Bool {
        return hasQueryItem(with: key, value: value?.rawValue)
    }

    private func hasQueryItem(with key: QueryItemKey, value: String? = nil) -> Bool {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryAccessToken = urlComponents?.queryItems?.filter { $0.name == key.rawValue && (value == nil || $0.value == value) }.last
        return queryAccessToken != nil
    }

    private func fragmentValue(for key: QueryItemKey) -> String? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let fragment = urlComponents.fragment else { return nil }

        urlComponents.query = fragment
        return urlComponents.url?.queryItemValue(for: key)
    }

}
