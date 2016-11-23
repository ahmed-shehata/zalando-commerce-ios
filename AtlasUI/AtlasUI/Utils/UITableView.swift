//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UITableView {

    fileprivate func reusableIdentifier(_ cellClass: AnyClass) -> String {
        return String(describing: cellClass)
    }

    func registerReusableCell(_ cellClass: AnyClass) {
        self.register(cellClass, forCellReuseIdentifier: reusableIdentifier(cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, forIndexPath indexPath: IndexPath,
        completion: (T) -> UITableViewCell) -> UITableViewCell {
            let cellId = reusableIdentifier(cellClass)
            guard let cell = self.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? T else {
                return UITableViewCell(style: .default, reuseIdentifier: cellId)
            }
            return completion(cell)
    }

}
