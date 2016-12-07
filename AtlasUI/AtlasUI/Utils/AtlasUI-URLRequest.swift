//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLRequest {

    private var acceptedLanguages: [String: Float] {
        return ["de": 0.6, "en": 0.4]
    }

    init(url: URL, language: String?) {
        self.init(url: url)
        guard let language = language else { return }
        self.setValue(acceptedLanguages(add: language), forHTTPHeaderField: "Accept-Language")
    }

    private func acceptedLanguages(add language: String) -> String {
        var languages = acceptedLanguages
        languages[language] = 1

        return languages.map { lang, quality in return "\(lang);q=\(quality)" }.joined(separator: ",")
    }

}
