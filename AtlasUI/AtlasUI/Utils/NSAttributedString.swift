//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {

    static func attributes(foregroundColor color: UIColor) -> [String: Any] {
        return [NSForegroundColorAttributeName: color]
    }

    static func attributes(font: UIFont) -> [String: Any] {
        return [NSFontAttributeName: font]
    }

    static func attributes(strikethroughColor color: UIColor) -> [String: Any] {
        return [
            NSStrikethroughStyleAttributeName: 1,
            NSStrikethroughColorAttributeName: color
        ]
    }

    func addForeground(color: UIColor) -> NSAttributedString {
        return self.add(attributes: NSAttributedString.attributes(foregroundColor: color))
    }

    func addFont(font: UIFont) -> NSAttributedString {
        return self.add(attributes: NSAttributedString.attributes(font: font))
    }

    func addStrikethrough(color: UIColor) -> NSAttributedString {
        return self.add(attributes: NSAttributedString.attributes(strikethroughColor: color))
    }

    func add(attributes: [String: Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: self.length)
        mutable.addAttributes(attributes, range: range)
        return NSAttributedString(attributedString: mutable)
    }

}
