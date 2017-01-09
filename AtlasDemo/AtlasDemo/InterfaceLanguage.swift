//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

enum InterfaceLanguage: String {

    case english = "en"
    case german = "de"
    case french = "fr"
    case italian = "it"
    case polish = "pl"

    static let all: [InterfaceLanguage] = [.english, .german, .french, .italian, .polish]

    init(index: Int) {
        self = InterfaceLanguage.all[index]
    }

    var name: String {
        let locale = NSLocale(localeIdentifier: self.rawValue)
        // swiftlint:disable:next force_unwrapping
        return locale.displayName(forKey: .identifier, value: self.rawValue)!
    }

}

enum SalesChannel: String {

    case germany = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
    case uk = "9c053041-b75d-4c4f-a3e2-4a484f70a809"

    static let all: [SalesChannel] = [.germany, .uk]

    init(index: Int) {
        self = SalesChannel.all[index]
    }

    var name: String {
        switch self {
        case .germany: return "Germany"
        case .uk: return "UK"
        }
    }

}
