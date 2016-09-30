//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK
import AtlasUI

class CatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var productCollectionView: UICollectionView!

    @IBOutlet weak var serverSwitch: UISwitch!
    var articles = [DemoArticle]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.productCollectionView.reloadData()
            }
        }
    }

    private let articlesClient = ArticlesClient()
    private let exampleImageView = UIImageView()
    private let sampleSKUs = ["L2711E002-Q11", "AZ711N007-Q11",
        "GU121D08Z-Q11", "AZ711N007-Q11", "AZ711N008-G11",
        "AZ711M001-B11", "AZ711N00B-Q11", "MK151F00E-Q11",
        "LA254E005-Q11", "HM141I009-J11", "EV941DA1B-G11",
        "ON581D004-O11", "SN541H00V-Q11", "BU311L00C-Q12",
        "AR322O01B-I11", "MA322E020-E11", "FOA51M001-Q11",
        "1VJ51H02P-Q11", "GU151G034-Q11", "P5011N001-Q11",
        "TI811B000-A11", "SH311N012-B11", "M0Q11L02W-J13",
        "M0Q21C06G-B11", "M0Q21C068-B11", "UG151B002-C11",
        "2SW51E08S-F11", "EV451D00U-302", "K4851H02E-Q11",
        "RA254E00M-O12", "RA252F005-802", "K0052E00Z-O11",
        "K0052E012-D11", "AJ152H012-Q11", "6CA51L00B-D11",
        "C1551E00K-F11", "PS752G001-Q11", "PX652G005-K11",
        "YO152G00A-C11", "BO152F027-Q11", "TP822C00N-Q11",
        "HU752E00G-A11", "TI522A03E-K11", "TI522D02K-A11"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        exampleImageView.image = UIImage(named: "example")
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        if let useSandbox = AppSetup.options?.useSandboxEnvironment {
            serverSwitch.on = useSandbox
        }
        self.navigationController?.navigationBar.accessibilityIdentifier = "catalog-navigation-controller"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadHomepageArticles()
    }

    private func loadHomepageArticles() {
        articlesClient.fetch(articlesForSKUs: sampleSKUs) { result in
            switch result {
            case .success(let articles):
                self.articles = articles
            case .failure(let error):
                self.showError(title: "Error", error: error)
            }
        }
    }

    @IBAction func serverSwitchTapped(serverSwitch: UISwitch) {
        AppSetup.change(environmentToSandbox: !serverSwitch.on)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath)
        guard let productCell = cell as? ProductCollectionViewCell else {
            return cell
        }

        productCell.setupCell(withArticle: articles[indexPath.row])
        return productCell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

}
