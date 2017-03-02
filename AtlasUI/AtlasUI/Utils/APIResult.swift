//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import AtlasSDK

// TODO: document it, please...

public enum ProcessedAtlasAPIResult<T> {

    case success(T)
    case error(error: Error, title: String, message: String)
    case handledInternally

}

extension APIResult {

    public func processedResult() -> ProcessedAtlasAPIResult<T> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error, var apiRequest):
            switch error {
            case APIError.unauthorized:
                let authorizationHandler = OAuth2AuthorizationHandler()
                authorizationHandler.authorize { result in
                    switch result {
                    case .success(let accessToken):
                        AtlasAPI.shared?.authorize(with: accessToken)
                        AtlasUIViewController.displayLoader { hideLoader in
                            apiRequest?.execute { _ in
                                hideLoader()
                            }
                        }
                    default:
                        break
                    }
                }
                return .handledInternally
            default:
                let userPresentable = error as? UserPresentableError ?? CheckoutError.unclassified
                return .error(error: error, title: userPresentable.displayedTitle, message: userPresentable.displayedMessage)
            }
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
        case .handledInternally:
            return nil
        }
    }

}
