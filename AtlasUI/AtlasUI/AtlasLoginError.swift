//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

/// Error thrown in case of login failures.
///
/// The message is translated and presented inside login controller
///
/// - seealso: `OAuth2LoginViewController`
///
/// - accessDenied: Regular case. Could happen in 2 cases:
///     - when a user doesn't give a consent
///     - when a token is invalid / expired
/// - requestFailed: Regular case, when connection problem occured.
/// - missingURL: Fatal unexpected case, when webview didn't have a URL to load.
///   Should never happen, but UIWebViewDelegate requires to handle this case.
/// - missingViewControllerToShowLoginForm: Fatal unexpected case, when there's
///   no controller from which a login controller could be presented for a user.
///   Should never happen, it's a grace exit.
enum AtlasLoginError: AtlasError {

    case accessDenied
    case requestFailed(error: Error?)

    case missingURL
    case missingViewControllerToShowLoginForm

}
