//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void
typealias RequestTaskCompletion = (RequestBuilder) -> Void

class RequestBuilder: Equatable {

    var executionFinished: RequestTaskCompletion?
    var urlSession: NSURLSession
    var endpoint: Endpoint
    private var dataTask: NSURLSessionDataTask?

    init(urlSession: NSURLSession = NSURLSession.sharedSession(), endpoint: Endpoint) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    deinit {
        dataTask?.cancel()
    }

    func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
                strongSelf.executionFinished?(strongSelf)
            case .success(let response):
                completion(.success(response))
                strongSelf.executionFinished?(strongSelf)
            }
        }
    }

    func buildAndExecuteSessionTask(completion: ResponseCompletion) {
        let request: NSMutableURLRequest
        do {
            request = try buildRequest().debugLog()
        } catch let e {
            return completion(.failure(e))
        }

        dataTask = self.urlSession.dataTaskWithRequest(request) { data, response, error in
            self.handleResponse(data, response, error, completion)
        }

        dataTask?.resume()
    }

    func buildRequest() throws -> NSMutableURLRequest {
        return try NSMutableURLRequest(endpoint: endpoint)
    }

    private func handleResponse(data: NSData?, _ response: NSURLResponse?, _ error: NSError?, _ completion: ResponseCompletion) {
        if let error = error {
            let nsURLError = AtlasAPIError.nsURLError(code: error.code, details: error.localizedDescription)
            return completion(.failure(nsURLError))
        }

        guard let httpResponse = response as? NSHTTPURLResponse, data = data else {
            return completion(.failure(AtlasAPIError.noData))
        }

        let json = JSON(data: data)

        guard httpResponse.isSuccessful else {
            let error: AtlasAPIError
            if json == JSON.null {
                error = AtlasAPIError.http(
                    status: HTTPStatus(statusCode: httpResponse.statusCode),
                    details: NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
            } else if httpResponse.status == .Unauthorized {
                error = AtlasAPIError.unauthorized
            } else {
                error = AtlasAPIError.backend(
                    status: json["status"].int,
                    title: json["title"].string,
                    details: json["detail"].string)
            }
            return completion(.failure(error))
        }

        completion(.success(JSONResponse(response: httpResponse, body: json)))
    }

}

func == (lhs: RequestBuilder, rhs: RequestBuilder) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
