//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URL {

    init(validURL stringConvertible: URLStringConvertible) {
        self.init(string: stringConvertible.urlString)! // swiftlint:disable:this force_unwrapping
    }

    init(validURL stringConvertible: URLStringConvertible, path: String? = nil) {
        self.init(validURL: URLComponents(validURL: stringConvertible, path: path))
    }

    func removeCookies(from storage: HTTPCookieStorage = HTTPCookieStorage.shared) {
        storage.cookies(for: self)?.forEach { cookie in
            storage.deleteCookie(cookie)
        }
    }

}
