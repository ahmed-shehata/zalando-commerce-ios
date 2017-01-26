//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class ArticleSelectionViewController: UIViewController {

    var selectedArticle: SelectedArticle {
        didSet {
            rootStackView.configure(viewModel: selectedArticle)
        }
    }

    fileprivate let rootStackView: ArticleSelectionRootStackView = {
        let stackView = ArticleSelectionRootStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    init(article: Article) {
        self.selectedArticle = SelectedArticle(article: article, unitIndex: 0, quantity: 1)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showCancelButton()
        buildView()
        rootStackView.configure(viewModel: selectedArticle)
    }

}

extension ArticleSelectionViewController: UIBuilder {

    func configureView() {
        view.addSubview(rootStackView)
        view.backgroundColor = .white
    }

    func configureConstraints() {
        rootStackView.fillInSuperview()
    }

}
