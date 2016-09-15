//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UITableView {

    private func reusableIdentifier(cellClass: AnyClass) -> String {
        return String(cellClass)
    }

    func registerReusableCell(cellClass: AnyClass) {
        self.registerClass(cellClass, forCellReuseIdentifier: reusableIdentifier(cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: NSIndexPath,
        completion: T -> UITableViewCell) -> UITableViewCell {
            let cellId = reusableIdentifier(cellClass)
            guard let cell = self.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? T else {
                return UITableViewCell(style: .Default, reuseIdentifier: cellId)
            }
            return completion(cell)
    }

}
