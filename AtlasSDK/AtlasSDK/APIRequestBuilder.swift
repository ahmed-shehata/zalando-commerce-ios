//
//  Copyright © 2016 Zalando SE. All rights reserved.
//


/*
@available(*, deprecated, message="Kill it with fire!")
final class APIRequestBuilder: RequestBuilder {

    private let loginURL: NSURL

    init(loginURL: NSURL, urlSession: NSURLSession = NSURLSession.sharedSession(), endpoint: Endpoint) {
        self.loginURL = loginURL
        super.init(urlSession: urlSession, endpoint: endpoint)
    }

    override func execute(completion: ResponseCompletion) {
        self.buildAndExecuteSessionTask { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .failure(let error):
                switch error {
                case AtlasAPIError.unauthorized:
                    guard UIApplication.hasTopViewController else {
                        return completion(.failure(error))
                    }
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.loginAndExecute(completion)
                    }
                default:
                    completion(.failure(error))
                    strongSelf.executionFinished?(strongSelf)
                }

            case .success(let response):
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    guard let strongSelf = self else { return }
                    completion(.success(response))
                    strongSelf.executionFinished?(strongSelf)
                }
            }

        }
    }

    private func loginAndExecute(completion: ResponseCompletion) {
        askUserToLogin { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let accessToken):
                APIAccessToken.store(accessToken)
                self.execute(completion)
            }
        }
    }

    private func askUserToLogin(completion: AtlasAuthorizationCompletion) {
        guard let topViewController = UIApplication.topViewController() else {
            return completion(.failure(LoginError.missingViewControllerToShowLoginForm))
        }

        let loginViewController = LoginViewController(loginURL: self.loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        dispatch_async(dispatch_get_main_queue()) {
            navigationController.modalPresentationStyle = .OverCurrentContext
            topViewController.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

}
 --*/
