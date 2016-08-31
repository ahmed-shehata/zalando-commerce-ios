//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

// TODO: remove the file
public class LoginError: AtlasError {

    init(code: LoginError.Code, message: String = "") {
        super.init(code: code.rawValue, message: message)
    }

}

public extension LoginError {

    public enum Code: Int {

        case Unknown = -1
        case MissingURL = 1
        case AccessDenied = 2
        case RequestFailed = 3
        case NoAccessToken = 4

    }

}
