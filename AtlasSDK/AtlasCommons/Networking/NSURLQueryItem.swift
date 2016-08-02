//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSURLQueryItem {

    public static func build(dict: [String: AnyObject?]) -> [NSURLQueryItem]? {
        return dict.flatMap { (name, value) in
            guard let value = value as? String else { return nil }
            return NSURLQueryItem(name: name, value: value)
        }
    }

}
