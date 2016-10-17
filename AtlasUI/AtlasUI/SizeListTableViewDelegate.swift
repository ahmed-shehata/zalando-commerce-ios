//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

typealias SizeListTableViewDelegateCompletion = (selectedArticleUnit: SelectedArticleUnit, userSelected: Bool) -> Void

class SizeListTableViewDelegate: NSObject {

    internal let article: Article
    private let completion: SizeListTableViewDelegateCompletion?

    init(article: Article, completion: SizeListTableViewDelegateCompletion?) {
        self.article = article
        self.completion = completion

        if article.hasSingleUnit {
            completion?(selectedArticleUnit: SelectedArticleUnit(article: article, selectedUnitIndex: 0), userSelected: false)
        }
    }

}

extension SizeListTableViewDelegate: UITableViewDataSource {

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.availableUnits.count
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(UnitSizeTableViewCell.self, forIndexPath: indexPath) { cell in
            let unit = self.article.availableUnits[indexPath.item]
            cell.configureData(unit)
            cell.accessibilityIdentifier = "size-cell-\(indexPath.row)"
            return cell
        }
    }

}

extension SizeListTableViewDelegate: UITableViewDelegate {

    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: indexPath.row)
        completion?(selectedArticleUnit: selectedArticleUnit, userSelected: true)
    }

}
