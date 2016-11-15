//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

public enum ProcessedAtlasResult<T> {

    case success(T)
    case error(error: ErrorType, title: String, message: String)
    case skipped

}

extension AtlasResult {

    public func processedResult() -> ProcessedAtlasResult<T> {
        switch self {
        case .failure(let error):
            switch error {
            case AtlasAPIError.unauthorized(let repeatCall):
                let authorizationHandler = OAuth2AuthorizationHandler()
                authorizationHandler.authorize { result in
                    let processedResult = result.processedResult()
                    switch processedResult {
                    case .success(let accessToken):
                        Atlas.login(accessToken)
                        UserMessage.displayLoader { hideLoader in
                            repeatCall {
                                hideLoader()
                            }
                        }
                    default: break
                    }
                }
                return .skipped

            case let userPresentable as UserPresentable:
                return .error(error: error, title: userPresentable.displayedTitle, message: userPresentable.displayedMessage)

            default:
                let unclassifiedError = AtlasCheckoutError.unclassified
                return .error(error: error, title: unclassifiedError.displayedTitle, message: unclassifiedError.displayedMessage)
            }
        case .success(let data):
            return .success(data)
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
        case .skipped:
            return nil
        }
    }

}
