//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public enum LoginError: LocalizableError {

    case accessDenied
    case requestFailed(error: Error?)

    case missingURL
    case missingViewControllerToShowLoginForm

}
