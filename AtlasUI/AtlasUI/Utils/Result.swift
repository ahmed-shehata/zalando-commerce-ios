//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import AtlasSDK

// TODO: document it, please...

public enum ProcessedResult<T> {

    case success(T)
    case error(error: Error, title: String, message: String)

}

extension Result {

    public func processedResult() -> ProcessedResult<T> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            let userPresentable = error as? UserPresentableError ?? AtlasCheckoutError.unclassified
            return .error(error: error, title: userPresentable.displayedTitle, message: userPresentable.displayedMessage)
        }
    }

    func process(presentationMode: PresentationMode? = nil) -> T? {
        let processedResult = self.processedResult()
        switch processedResult {
        case .success(let data):
            return data
        case .error(let error, _, _):
            UserError.display(error: error, mode: presentationMode)
            return nil
        }
    }

}
