//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void
typealias RequestTaskCompletion = (RequestBuilder) -> Void

class RequestBuilder: Equatable {

    var executionFinished: RequestTaskCompletion?
    var urlSession: NSURLSession
    var endpoint: EndpointType
    private var dataTask: NSURLSessionDataTask?

    init(urlSession: NSURLSession = NSURLSession.sharedSession(), endpoint: EndpointType) {
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
        var request: NSMutableURLRequest!
        do {
            request = try buildRequest().debugLog()
        } catch let e {
            completion(.failure(e))
            return
        }

        dataTask = self.urlSession.dataTaskWithRequest(request,
            completionHandler: { data, response, error in
                if let error = error {
                    let httpStatus = HTTPStatus(statusCode: error.code)
                    let httpError = AtlasAPIError.HTTP(status: httpStatus, details: error.localizedDescription)
                    completion(.failure(httpError))
                    return
                }

                guard let httpResponse = response as? NSHTTPURLResponse, data = data else {
                    completion(.failure(AtlasAPIError.NoData))
                    return
                }

                let json = JSON(data: data)

                guard httpResponse.isSuccessful else {
                    let backendError = AtlasAPIError.Backend(status: json["status"].int,
                        title: json["title"].string, details: json["detail"].string)
                    completion(.failure(backendError))
                    return
                }

                completion(.success(JSONResponse(response: httpResponse, body: json)))
        })

        dataTask?.resume()
    }

    func buildRequest() throws -> NSMutableURLRequest {
        return try NSMutableURLRequest(endpoint: endpoint)
    }

}

func == (lhs: RequestBuilder, rhs: RequestBuilder) -> Bool {
    return unsafeAddressOf(lhs) == unsafeAddressOf(rhs)
}
