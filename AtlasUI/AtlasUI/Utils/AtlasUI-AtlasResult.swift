//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

public enum ProcessedAtlasResult<T> {

    case success(T)
    case error(error: Error, title: String, message: String)

}

extension AtlasResult {

    public func processedResult() -> ProcessedAtlasResult<T> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            let userPresentable = error as? UserPresentable ?? AtlasCheckoutError.unclassified
            return .error(error: error, title: userPresentable.displayedTitle, message: userPresentable.displayedMessage)
        }
    }

    func process(forceFullScreenError fullScreen: Bool = false) -> T? {
        let processedResult = self.processedResult()
        switch processedResult {
        case .success(let data):
            return data
        case .error(let error, _, _):
            if fullScreen {
                UserMessage.displayErrorFullScreen(error)
            } else {
                UserMessage.displayError(error)
            }
            return nil
        }
    }

}
