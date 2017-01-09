//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public enum AtlasLoginError: AtlasError {

    case missingURL
    case accessDenied
    case missingViewControllerToShowLoginForm

    case requestFailed(error: Error?)

}
