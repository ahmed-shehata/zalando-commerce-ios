//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func success(userMessage: UserMessage) -> T? {
        switch self {
        case .failure(let error):
            displayError(error, userMessage: userMessage)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType, userMessage: UserMessage) {
        guard let atlasError = error as? AtlasErrorType else {
            // TODO: Need to check for network errors and other types
            userMessage.generalError()
            return
        }

        let atlasUIViewController: AtlasUIViewController? = try? Injector.provide()
        if let atlasUIViewController = atlasUIViewController where atlasError.shouldCancelCheckout() {
            atlasUIViewController.dismissViewControllerAnimated(true) {
                self.displayErrorMessage(atlasError, userMessage: userMessage)
            }
        } else {
            displayErrorMessage(atlasError, userMessage: userMessage)
        }
    }

    private func displayErrorMessage(error: AtlasErrorType, userMessage: UserMessage) {
        if error.shouldDisplayGeneralMessage() {
            userMessage.generalError()
        } else {
            userMessage.show(error: error)
        }
    }

}
