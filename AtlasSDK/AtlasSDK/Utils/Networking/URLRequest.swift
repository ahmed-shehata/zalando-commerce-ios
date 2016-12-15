//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLRequest {

    func curlCommandRepresentation() -> String {
        var curlComponents = ["curl -i"]

        guard let URL = self.url else { return "curl command could not be created" }

        curlComponents.append("-X \(self.httpMethod ~? "GET")")

        self.allHTTPHeaderFields?.forEach {
            curlComponents.append("-H \"\($0): \($1)\"")
        }

        if let HTTPBodyData = self.httpBody,
            let HTTPBody = String(data: HTTPBodyData, encoding: String.Encoding.utf8) {
                var escapedBody = HTTPBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
                escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

                curlComponents.append("-d \"\(escapedBody)\"")
        }

        curlComponents.append("\"\(URL.urlString)\"")

        return curlComponents.joined(separator: " \\\n\t")
    }

    func debugLog() -> URLRequest {
        AtlasLogger.logDebug(curlCommandRepresentation())
        return self
    }

    @discardableResult
    mutating func authorize(withToken token: String?) -> URLRequest {
        if let token = token {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return self
    }

    init(endpoint: Endpoint) throws {
        self.init(url: endpoint.url)
        self.setHeaders(from: endpoint)
        self.httpMethod = endpoint.method.rawValue
        self.httpBody = try Data(withJSONObject: endpoint.parameters)
    }

    fileprivate mutating func setHeaders(from endpoint: Endpoint) {
        var headers: [String: String] = [:]

        setContentType(for: endpoint, headers: &headers)
        setUserAgent(headers: &headers)

        headers.forEach { header, value in
            self.setValue(value, forHTTPHeaderField: header)
        }

        endpoint.headers?.forEach { header, value in
            self.setValue(String(describing: value), forHTTPHeaderField: header)
        }
    }

    fileprivate func setContentType(for endpoint: Endpoint, headers: inout [String: String]) {
        let acceptedContentTypes = [endpoint.acceptedContentType, "application/x.problem+json"].flatMap { $0 }
        headers["Accept"] = acceptedContentTypes.joined(separator: ",")
        headers["Content-Type"] = endpoint.contentType
    }

    fileprivate func setUserAgent(headers: inout [String: String]) {
        let bundle = Bundle(for: RFC3339DateFormatter.self)
        let sdkVersion = bundle.string(for: "CFBundleVersion")
        let buildVersion = bundle.string(for: "CFBundleShortVersionString")
        let device = SystemInfo.machine
        let systemVersion = UIDevice.current.systemVersion

        headers["User-Agent"] = "AtlasSDK iOS \(sdkVersion~?) (\(buildVersion~?)), \(device~?)/\(systemVersion)"
    }

}
