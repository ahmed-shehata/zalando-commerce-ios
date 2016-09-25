//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void

struct RequestBuilder {

    let endpoint: Endpoint
    let urlSession: NSURLSession

    init(forEndpoint endpoint: Endpoint, urlSession: NSURLSession = NSURLSession.sharedSession()) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error, verbose: true)
                switch error {
                case AtlasAPIError.unauthorized:
                    guard let authorizationHandler = try? Atlas.provide() as AuthorizationHandler else {
                        return completion(.failure(error))
                    }
                    authorizationHandler.authorize { result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let accessToken):
                            APIAccessToken.store(accessToken)
                            self.execute(completion)
                        }
                    }
                default:
                    completion(.failure(error))
                }

            case .success(let response):
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.success(response))
                }
            }
        }
    }

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
