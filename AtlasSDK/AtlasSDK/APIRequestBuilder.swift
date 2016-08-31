//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

final class APIRequestBuilder: RequestBuilder {

    private let loginURL: NSURL

    init(loginURL: NSURL, urlSession: NSURLSession = NSURLSession.sharedSession(), endpoint: EndpointType) {
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
                        completion(.failure(error))
                        return
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

    override func buildRequest() throws -> NSMutableURLRequest {
        return try super.buildRequest().authorize(withToken: APIAccessToken.retrieve())
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

    private func askUserToLogin(completion: LoginCompletion) {
        guard let sourceApp = UIApplication.topViewController() else {
            completion(.failure(LoginError.missingViewControllerToShowLoginForm))
            return
        }

        let loginViewController = LoginViewController(loginURL: self.loginURL, completion: completion)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        dispatch_async(dispatch_get_main_queue()) {
            navigationController.modalPresentationStyle = .OverCurrentContext
            sourceApp.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

}
