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

    private var printRequestDescription: Bool {
        return NSProcessInfo.processInfo().arguments.contains("PRINT_REQUEST_DESCRIPTION")
    }

    init(forEndpoint endpoint: Endpoint, urlSession: NSURLSession = NSURLSession.sharedSession()) {
        self.urlSession = urlSession
        self.endpoint = endpoint
    }

    mutating func execute(completion: ResponseCompletion) {
        buildAndExecuteSessionTask({ repeatCompletion in
            self.execute { result in
                dispatch_async(dispatch_get_main_queue()) {
                    repeatCompletion()
                }
                completion(result)
            }
        }) { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError("Failed request:", self.endpoint, "with error:", error)
                completion(.failure(error))

            case .success(let response):
                completion(.success(response))
            }
        }
    }

    private mutating func buildAndExecuteSessionTask(repeatCall: RepeatCallAction, completion: ResponseCompletion) {
        let request: NSMutableURLRequest
        do {
            request = try buildRequest()
            self.request = request
        } catch let e {
            return completion(.failure(e))
        }

        self.urlSession.dataTaskWithRequest(request) { response in
            (self.responseData, self.response, self.responseError) = response
            if self.printRequestDescription {
                print(self.description)
            }
            ResponseParser(taskResponse: response).parse(repeatCall, completion: completion)
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
            desc += "\n🔴 REQUEST:\n"
            desc += "URL: \(request.URL!)\n" // swiftlint:disable:this force_unwrapping
            desc += "Method: \(request.HTTPMethod ?? "")\n"
            request.allHTTPHeaderFields?.forEach { key, val in
                desc += "\(key): \(val)\n"
            }
            if let bodyData = request.HTTPBody, body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                desc += "⭕️ BODY: \(body.whiteCharactersFreeString)\n"
            }
        } else {
            desc += "<NO REQUEST DATA>\n"
        }

        if let response = self.response as? NSHTTPURLResponse {
            desc += "\n🔵 RESPONSE:\n"
            response.allHeaderFields.forEach { key, val in
                desc += "\(key): \(val)\n"
            }
            if let bodyData = responseData, body = String(data: bodyData, encoding: NSUTF8StringEncoding) {
                desc += "⭕️ BODY: \(body.whiteCharactersFreeString)\n"
            }
        } else {
            desc += "<NO RESPONSE DATA>\n"
        }

        return desc
    }

}
