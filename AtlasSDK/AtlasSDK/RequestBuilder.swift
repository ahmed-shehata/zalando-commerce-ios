//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void
typealias RequestTaskCompletion = (RequestBuilder) -> Void

public typealias AtlasAuthorizationToken = String
public typealias AtlasAuthorizationCompletion = AtlasResult<AtlasAuthorizationToken> -> Void

public protocol AtlasAuthorizationHandler {

    func authorizeTask(completion: AtlasAuthorizationCompletion)

}

struct RequestBuilder: Equatable {

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

    mutating func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask { result in
            switch result {
            case .failure(let error):
                switch error {
                case AtlasAPIError.unauthorized:
                    guard let authorizationHandler = self.authorizationHandler else {
                        return completion(.failure(error))
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        authorizationHandler.authorizeTask { result in
                            switch result {
                            case .failure(let error):
                                completion(.failure(error))
                                self.executionFinished?(self)
                            case .success(let accessToken):
                                APIAccessToken.store(accessToken)
                                self.execute(completion)
                            }
                            // TODO: strongSelf.executionFinished?(strongSelf) after authorizeTask
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

    mutating func buildAndExecuteSessionTask(completion: ResponseCompletion) {
        let request: NSMutableURLRequest
        do {
            request = try buildRequest()
        } catch let e {
            return completion(.failure(e))
        }

        dataTask = self.urlSession.dataTaskWithRequest(request) { data, response, error in
            self.handleResponse(data, response, error, completion)
        }

        dataTask?.resume()
    }

    func buildRequest() throws -> NSMutableURLRequest {
        let request = try NSMutableURLRequest(endpoint: endpoint).debugLog()
        return request.authorize(withToken: APIAccessToken.retrieve())
    }

    // TODO: sepratated struct
    private func handleResponse(data: NSData?, _ response: NSURLResponse?, _ error: NSError?, _ completion: ResponseCompletion) {
        if let error = error {
            let nsURLError = AtlasAPIError.nsURLError(code: error.code, details: error.localizedDescription)
            return completion(.failure(nsURLError))
        }

        guard let httpResponse = response as? NSHTTPURLResponse, data = data else {
            return completion(.failure(AtlasAPIError.noData))
        }

        let json: JSON? = data.length > 0 ? JSON(data: data) : nil

        guard httpResponse.isSuccessful else {
            let error: AtlasAPIError
            if httpResponse.status == .Unauthorized {
                error = AtlasAPIError.unauthorized
            } else if let json = json where json != JSON.null {
                error = AtlasAPIError.backend(
                    status: json["status"].int,
                    title: json["title"].string,
                    details: json["detail"].string)
            } else {
                error = AtlasAPIError.http(
                    status: HTTPStatus(statusCode: httpResponse.statusCode),
                    details: NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
            }
            return completion(.failure(error))
        }

        completion(.success(JSONResponse(response: httpResponse, body: json)))
    }

}

func ==(lhs: RequestBuilder, rhs: RequestBuilder) -> Bool {
    return lhs.identifier == rhs.identifier
}