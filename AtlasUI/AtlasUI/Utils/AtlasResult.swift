//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func success() -> T? {
        switch self {
        case .failure(let error):
            displayError(error)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType) {
        guard let userPresentable = error as? UserPresentable else {
            // TODO: Need to check for network errors and other types
            UserMessage.unclasifiedError(error)
            return
        }

        let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
        if let atlasUIViewController = atlasUIViewController where userPresentable.shouldCancelCheckout() {
            atlasUIViewController.dismissViewControllerAnimated(true) {
                self.displayErrorMessage(userPresentable)
            }
        } else {
            displayErrorMessage(userPresentable)
        }
    }

    private func displayErrorMessage(userPresentable: UserPresentable) {
        if userPresentable.shouldDisplayGeneralMessage() {
            UserMessage.unclasifiedError(userPresentable)
        } else {
            UserMessage.show(error: userPresentable)
        }
    }

}
