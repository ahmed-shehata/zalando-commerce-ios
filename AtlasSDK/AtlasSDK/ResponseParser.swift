//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias DataTaskResponse = (data: NSData?, urlResponse: NSURLResponse?, error: NSError?)

struct ResponseParser {

    let taskResponse: DataTaskResponse

    func parse(completion: ResponseCompletion) {
        if let error = taskResponse.error {
            let nsURLError = AtlasAPIError.nsURLError(code: error.code, details: error.localizedDescription)
            return completion(.failure(nsURLError))
        }

        guard let httpResponse = taskResponse.urlResponse as? NSHTTPURLResponse, data = taskResponse.data else {
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
