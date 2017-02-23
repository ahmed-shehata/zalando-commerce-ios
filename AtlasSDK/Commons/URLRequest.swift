//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension URLRequest {

    init(url: URL, language: String?) {
        guard let language = language else {
            self.init(url: url)
            return
        }

        var urlComponents = URLComponents(validURL: url)
        urlComponents.append(queryItems: ["lng": language])
        self.init(url: urlComponents.validURL)
        self.setValue(acceptedLanguages(add: language), forHTTPHeaderField: "Accept-Language")
    }

    func curlCommandRepresentation() -> String {
        var curlComponents = ["curl -i"]

        guard let url = self.url else { return "curl command could not be created" }

        curlComponents.append("-X \(self.httpMethod ~? "GET")")

        self.allHTTPHeaderFields?.forEach {
            curlComponents.append("-H \"\($0): \($1)\"")
        }

        if let HTTPBodyData = self.httpBody,
            let body = String(data: HTTPBodyData, encoding: String.Encoding.utf8) {
            var escapedBody = body.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            curlComponents.append("-d \"\(escapedBody)\"")
        }

        curlComponents.append("\"\(url.urlString)\"")

        return curlComponents.joined(separator: " \\\n\t")
    }

    @discardableResult
    mutating func authorize(withToken token: String?) -> URLRequest {
        if let token = token {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return self
    }

    private var acceptedLanguages: [String: Float] {
        return ["de": 0.6, "en": 0.4]
    }

    private func acceptedLanguages(add language: String) -> String {
        var languages = acceptedLanguages
        languages[language] = 1

        return languages.map { lang, quality in return "\(lang);q=\(quality)" }.joined(separator: ",")
    }

}
