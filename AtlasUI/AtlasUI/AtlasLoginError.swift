//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

// TODO: Remove "Atlas" from name

enum AtlasLoginError: AtlasError {

    case accessDenied
    case requestFailed(error: Error?)

    case missingURL
    case missingViewControllerToShowLoginForm

}
