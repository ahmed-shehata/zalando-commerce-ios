//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI
import ZalandoCommerceUI
import Nuke

class PDPViewController: UIViewController {

    var sku: ConfigSKU?

    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var colorLabel: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveArticleDetails()
    }

    func retrieveArticleDetails() {
        guard let sku = sku else { return }

        AppSetup.zCommerceUI?.api.article(with: sku) { [weak self] result in
            let processedResult = result.processedResult()
            switch processedResult {
            case .success(let article):
                self?.brandLabel.text = article.brand.name
                self?.nameLabel.text = article.name
                self?.colorLabel.text = article.color

                if let imageURL = article.media?.mediaItems.first?.detailHDURL, let thumbImageView = self?.thumbImageView {
                    Nuke.loadImage(with: imageURL, into: thumbImageView)
                }

            case .error(_, let title, let message):
                UIAlertController.showMessage(title: title, message: message)

            case .handledInternally:
                break
            }

            self?.loader.stopAnimating()
            self?.loader.isHidden = true
        }
    }

}
