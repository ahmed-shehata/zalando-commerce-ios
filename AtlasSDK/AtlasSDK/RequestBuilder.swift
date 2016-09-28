//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ResponseCompletion = AtlasResult<JSONResponse> -> Void

struct RequestBuilder {

    let endpoint: Endpoint
    let urlSession: NSURLSession

    private var request: NSURLRequest?
    private var response: NSURLResponse?
    private var responseData: NSData?
    private var responseError: NSError?

    init(forEndpoint endpoint: Endpoint, urlSession: NSURLSession = NSURLSession.sharedSession()) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    mutating func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask { result in
            switch result {
            case .failure(let error):
                switch error {
                case AtlasAPIError.unauthorized:
                    guard let authorizationHandler = try? Injector.provide() as AuthorizationHandler else {
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
                completion(.success(response))
            }
        }
    }

    private mutating func buildAndExecuteSessionTask(completion: ResponseCompletion) {
        let request: NSMutableURLRequest
        do {
            request = try buildRequest()
            self.request = request
        } catch let e {
            return completion(.failure(e))
        }

        self.urlSession.dataTaskWithRequest(request) { response in
            (self.responseData, self.response, self.responseError) = response
            ResponseParser(taskResponse: response).parse(completion)
        }.resume()
    }

    private func buildRequest() throws -> NSMutableURLRequest {
        let request = try NSMutableURLRequest(endpoint: endpoint)
        guard endpoint.requiresAuthorization else {
            return request.debugLog()
        }
        return request.authorize(withToken: APIAccessToken.retrieve()).debugLog()
    }

}

extension RequestBuilder: CustomStringConvertible {

    var description: String {

        var desc = ""
        if let request = request {
            desc += "REQUEST:\n"
            desc += "\(request.HTTPMethod) \(request.URL!)\n\n" // swiftlint:disable:this force_unwrapping
            request.allHTTPHeaderFields?.forEach { key, val in
                desc += "\(key): \(val)"
            }
            if let bodyData = request.HTTPBody, body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                desc += "\n\(body)"
            }
        } else {
            desc += "<NO REQUEST DATA>\n"
        }

        if let response = self.response as? NSHTTPURLResponse {
            desc += "RESPONSE:\n"
            response.allHeaderFields.forEach { key, val in
                desc += "\(key): \(val)"
            }
            if let bodyData = responseData, body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                desc += "\n\(body)"
            }
        } else {
            desc += "<NO RESPONSE DATA>\n"
        }

        return desc
    }

}
