//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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

    case germany = "01924c48-49bb-40c2-9c32-ab582e6db6f4"
    case uk = "83c4e87f-6819-41bb-af61-46cddb8453f5"

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
