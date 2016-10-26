//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

@testable import AtlasSDK

struct MockAuthorizationHandler: AuthorizationHandler {

    var token: String?
    var error: ErrorType?

    enum Error: ErrorType {
        case unknown
    }

    init(token: String = "TOKEN") {
        self.token = token
        self.error = nil
    }

    init(error: ErrorType) {
        self.token = nil
        self.error = error
    }

    func authorize(completion: AuthorizationCompletion) {
        if let token = token {
            completion(.success(token))
        } else if let error = error {
            completion(.failure(error))
        } else {
            completion(.failure(Error.unknown))
        }
    }

}
