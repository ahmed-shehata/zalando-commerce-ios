//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

class SizeListTableViewDataSource: NSObject {

    let article: Article

    init(article: Article) {
        self.article = article
    }

}

extension SizeListTableViewDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.availableUnits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(of: UnitSizeTableViewCell.self, at: indexPath) { cell in
            let unit = self.article.availableUnits[indexPath.item]
            cell.configure(viewModel: unit)
            cell.accessibilityIdentifier = "size-cell-\(indexPath.row)"
            return cell
        }
    }

}
