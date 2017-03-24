//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

// TODO: document it, please...

public enum LoginError: LocalizableError {

    case accessDenied
    case requestFailed(error: Error?)

    case missingURL
    case missingViewControllerToShowLoginForm

}
