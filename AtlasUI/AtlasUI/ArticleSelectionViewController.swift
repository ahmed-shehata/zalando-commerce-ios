//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionViewController: UIViewController {

    var articleUnit: SelectedArticle

    init(article: Article) {
        self.articleUnit = SelectedArticle(article: article, selectedUnitIndex: 0)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
