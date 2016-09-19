//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void
typealias RequestTaskCompletion = (RequestBuilder) -> Void

final class RequestBuilder: Equatable {

    // TODO: Could be dropped probably
    var executionFinished: RequestTaskCompletion?
    var authorizationHandler: AtlasAuthorizationHandler?

    let urlSession: NSURLSession
    let endpoint: Endpoint

    private let identifier: UInt32
    private var dataTask: NSURLSessionDataTask?

    init(urlSession: NSURLSession = NSURLSession.sharedSession(), endpoint: Endpoint) {
        self.urlSession = urlSession
        self.endpoint = endpoint
        self.identifier = arc4random()
    }

    deinit {
        dataTask?.cancel()
    }

    // TODO: Find more meaningful name
    func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask { result in
            switch result {
            case .failure(let error):
                switch error {
                case AtlasAPIError.unauthorized:
                    guard let authorizationHandler = self.authorizationHandler else {
                        return completion(.failure(error))
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        authorizationHandler.authorize { result in
                            switch result {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success(let accessToken):
                                APIAccessToken.store(accessToken)
                                self.execute(completion)
                            }
                            self.executionFinished?(self)
                        }
                    }
                default:
                    completion(.failure(error))
                    self.executionFinished?(self)
                }

            case .success(let response):
                completion(.success(response))
                self.executionFinished?(self)
            }
        }
    }

    // TODO: Find more meaningful name
    private func buildAndExecuteSessionTask(completion: ResponseCompletion) {
        let request: NSMutableURLRequest
        do {
            request = try buildRequest()
        } catch let e {
            return completion(.failure(e))
        }

        self.urlSession.dataTaskWithRequest(request) { response in
            ResponseParser(taskResponse: response).parse(completion)
        }.resume()

    }

    private func buildRequest() throws -> NSMutableURLRequest {
        let request = try NSMutableURLRequest(endpoint: endpoint).debugLog()
        return request.authorize(withToken: APIAccessToken.retrieve())
    }

}

func == (lhs: RequestBuilder, rhs: RequestBuilder) -> Bool {
    return lhs.identifier == rhs.identifier
}
