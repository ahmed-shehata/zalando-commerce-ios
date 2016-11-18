//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension URLQueryItem {

    static func build(_ dict: [String: AnyObject?]) -> [URLQueryItem]? {
        return dict.flatMap { (name, value) in
            guard let value = value as? String else { return nil }
            return URLQueryItem(name: name, value: value)
        }
    }

}
