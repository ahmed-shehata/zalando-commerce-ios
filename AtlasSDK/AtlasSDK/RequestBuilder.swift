//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = (AtlasResult<JSONResponse>) -> Void

struct RequestBuilder {

    let endpoint: Endpoint
    let urlSession: URLSession

    fileprivate(set) var taskResponse: DataTaskResponse?

    init(forEndpoint endpoint: Endpoint, urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    func execute(completion: @escaping ResponseCompletion) {
        let endpoint = self.endpoint
        buildAndExecuteSessionTask { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError("FAILED CONNECTION:", type(of: endpoint), "\nERROR:", error)
                completion(.failure(error))

            case .success(let response):
                completion(.success(response))
            }
        }
    }

    fileprivate func buildAndExecuteSessionTask(completion: @escaping ResponseCompletion) {
        let request: URLRequest
        do {
            request = try buildRequest()
        } catch let e {
            return completion(.failure(e))
        }

        self.urlSession.dataTask(with: request) { data, response, error in
            let taskResponse = DataTaskResponse(request: request, response: response, data: data, error: error)
            ResponseParser(taskResponse: taskResponse).parse(completion: completion)
            }
            .resume()

    }

    fileprivate func buildRequest() throws -> URLRequest {
        let request: URLRequest = try {
            var r = try URLRequest(endpoint: self.endpoint)
            if let token = self.endpoint.authorizationToken {
                r.authorize(withToken: token)
            }
            return r
            }()

        return request.debugLog()
    }

}
