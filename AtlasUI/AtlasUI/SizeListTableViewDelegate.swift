//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

typealias SizeListTableViewDelegateCompletion = (selectedArticleUnit: SelectedArticleUnit) -> Void

class SizeListTableViewDelegate: NSObject {

    internal let article: Article
    private let completion: SizeListTableViewDelegateCompletion?

    init(article: Article, completion: SizeListTableViewDelegateCompletion?) {
        self.article = article
        self.completion = completion

        if article.hasSingleUnit {
            completion?(selectedArticleUnit: SelectedArticleUnit(article: article, selectedUnitIndex: 0))
        }
    }

}

extension SizeListTableViewDelegate: UITableViewDelegate {

    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: indexPath.row)
        completion?(selectedArticleUnit: selectedArticleUnit)
    }

}
