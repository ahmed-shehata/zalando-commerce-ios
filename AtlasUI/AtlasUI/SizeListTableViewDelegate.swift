//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias SizeListTableViewDelegateCompletion = (SelectedArticle) -> Void

class SizeListTableViewDelegate: NSObject {

    let article: Article
    fileprivate let completion: SizeListTableViewDelegateCompletion

    init(article: Article, completion: @escaping SizeListTableViewDelegateCompletion) {
        self.article = article
        self.completion = completion
    }

}

extension SizeListTableViewDelegate: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedArticle = SelectedArticle(article: article, unitIndex: indexPath.row, quantity: 1)
        completion(selectedArticle)
    }

}
