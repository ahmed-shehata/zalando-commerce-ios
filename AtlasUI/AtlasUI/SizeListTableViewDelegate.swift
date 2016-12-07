//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK

typealias SizeListTableViewDelegateCompletion = (_ selectedArticleUnit: SelectedArticleUnit) -> Void

class SizeListTableViewDelegate: NSObject {

    let article: Article
    fileprivate let completion: SizeListTableViewDelegateCompletion?

    init(article: Article, completion: SizeListTableViewDelegateCompletion?) {
        self.article = article
        self.completion = completion

        if article.hasSingleUnit {
            completion?(SelectedArticleUnit(article: article, selectedUnitIndex: 0))
        }
    }

}

extension SizeListTableViewDelegate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: indexPath.row)
        completion?(selectedArticleUnit)
    }

}
