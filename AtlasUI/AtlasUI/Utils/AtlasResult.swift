//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

extension AtlasResult {

    internal func process() -> T? {
        switch self {
        case .failure(let error):
            displayError(error)
            return nil
        case .success(let data):
            return data
        }
    }

    private func displayError(error: ErrorType) {
        let viewController: AtlasUIViewController? = try? Atlas.provide()
        guard let userPresentable = error as? UserPresentable, atlasUIViewController = viewController else {
            UserMessage.unclassifiedError(error)
            return
        }

        atlasUIViewController.displayError(userPresentable)
    }

}
