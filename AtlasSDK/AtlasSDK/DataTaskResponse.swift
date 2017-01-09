//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

struct DataTaskResponse {

    let request: URLRequest
    let response: HTTPURLResponse?
    let data: Data?
    let error: NSError?

    fileprivate var logDebug: Bool {
        return ProcessInfo.processInfo.arguments.contains("PRINT_REQUEST_DESCRIPTION")
    }

    init(request: URLRequest, response: URLResponse?, data: Data?, error: Error?) {
        self.request = request
        self.response = response as? HTTPURLResponse
        self.data = data
        self.error = error as? NSError

        if logDebug {
            AtlasLogger.logDebug(self)
        }
    }

}

extension DataTaskResponse: CustomStringConvertible {

    var description: String {
        var desc = "\n🔴 REQUEST:\n"
            + "URL: \(request.url!)\n" // swiftlint:disable:this force_unwrapping
            + "Method: \(request.httpMethod ?? "")\n"

        request.allHTTPHeaderFields?.forEach { key, val in
            desc += "\(key): \(val)\n"
        }
        if let bodyData = request.httpBody, let body = String(data: bodyData, encoding: String.Encoding.utf8) {
            desc += "⭕️ BODY: \(body.whitespaceCompacted())\n"
        }

        if let response = self.response {
            desc += "\n🔵 RESPONSE:\n"
            response.allHeaderFields.forEach { key, val in
                desc += "\(key): \(val)\n"
            }
            if let bodyData = data, let body = String(data: bodyData, encoding: String.Encoding.utf8) {
                desc += "⭕️ BODY: \(body.whitespaceCompacted())\n"
            }
        } else {
            desc += "<NO RESPONSE DATA>\n"
        }

        return desc
    }

}
