//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    fileprivate func reusableIdentifier(for cellClass: AnyClass) -> String {
        return String(describing: cellClass)
    }

    func registerReusableCell(for cellClass: AnyClass) {
        self.register(cellClass, forCellReuseIdentifier: reusableIdentifier(for: cellClass))
    }

    func dequeueReusableCell<T: UITableViewCell>(of cellClass: T.Type, at indexPath: IndexPath,
                             completion: (T) -> UITableViewCell) -> UITableViewCell {
        let cellId = reusableIdentifier(for: cellClass)
        guard let cell = self.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? T else {
            return UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        return completion(cell)
    }

}
