//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

public enum ProcessedAtlasAPIResult<T> {

    case success(T)
    case error(error: ErrorType, title: String, message: String)
    case handledInternally

}

extension AtlasAPIResult {

    public func processedResult() -> ProcessedAtlasAPIResult<T> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return processError(error)
        case .abortion(let error, var apiRequest):
            switch error {
            case AtlasAPIError.unauthorized:
                let authorizationHandler = OAuth2AuthorizationHandler()
                authorizationHandler.authorize { result in
                    switch result {
                    case .success(let accessToken):
                        Atlas.login(accessToken)
                        UserMessage.displayLoader { hideLoader in
                            apiRequest.execute { _ in
                                hideLoader()
                            }
                        }
                    default:
                        break
                    }
                }
                return .handledInternally
            default:
                return processError(error)
            }
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
        case .handledInternally:
            return nil
        }
    }

    private func processError(error: ErrorType) -> ProcessedAtlasAPIResult<T> {
        let userPresentable = error as? UserPresentable ?? AtlasCheckoutError.unclassified
        return .error(error: error, title: userPresentable.displayedTitle, message: userPresentable.displayedMessage)
    }

}
