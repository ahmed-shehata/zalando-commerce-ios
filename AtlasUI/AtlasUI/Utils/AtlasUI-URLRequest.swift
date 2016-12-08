//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension URLRequest {

    private var acceptedLanguages: [String: Float] {
        return ["de": 0.6, "en": 0.4]
    }

    init(url: URL, config: Config?) {
        self.init(url: url, language: config?.salesChannel.languageCode)
    }

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

    private func acceptedLanguages(add language: String) -> String {
        var languages = acceptedLanguages
        languages[language] = 1

        return languages.map { lang, quality in return "\(lang);q=\(quality)" }.joined(separator: ",")
    }

}
