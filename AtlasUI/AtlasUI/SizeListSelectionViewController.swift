//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias SizeListSelectionViewControllerCompletion = (SelectedArticle) -> Void

final class SizeListSelectionViewController: UIViewController {

    let article: Article
    let completion: SizeListSelectionViewControllerCompletion

    // swiftlint:disable:next weak_delegate
    var tableViewDelegate: SizeListTableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    var tableViewDataSource: SizeListTableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = false
        return tableView
    }()

    init(article: Article, completion: @escaping SizeListSelectionViewControllerCompletion) {
        self.article = article
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }

}

extension SizeListSelectionViewController: UIBuilder {

    func configureView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.registerReusableCell(for: UnitSizeTableViewCell.self)
        tableViewDelegate = SizeListTableViewDelegate(article: article) { [weak self] selectedArticle in
            self?.completion(selectedArticle)
            _ = self?.navigationController?.popViewController(animated: true)
        }
        tableViewDataSource = SizeListTableViewDataSource(article: article)
    }

    func configureConstraints() {
        tableView.fillInSuperview()
    }

}
