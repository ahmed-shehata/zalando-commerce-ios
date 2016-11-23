//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public enum AtlasLoginError: AtlasErrorType {

    case missingURL
    case accessDenied
    case missingViewControllerToShowLoginForm

    case requestFailed(error: Error?)

}
