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
        guard let userPresentable = error as? UserPresentable else {
            // TODO: Need to check for network errors and other types
            userMessage.generalError()
            return
        }

        let atlasUIViewController: AtlasUIViewController? = try? Injector.provide()
        if let atlasUIViewController = atlasUIViewController where userPresentable.shouldCancelCheckout() {
            atlasUIViewController.dismissViewControllerAnimated(true) {
                self.displayErrorMessage(userPresentable, userMessage: userMessage)
            }
        } else {
            displayErrorMessage(userPresentable, userMessage: userMessage)
        }
    }

    private func displayErrorMessage(userPresentable: UserPresentable, userMessage: UserMessage) {
        if userPresentable.shouldDisplayGeneralMessage() {
            userMessage.generalError()
        } else {
            userMessage.show(error: userPresentable)
        }
    }

}
