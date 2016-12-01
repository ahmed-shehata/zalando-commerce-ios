//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK
import AtlasUI
import Nuke

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    var article: DemoArticle?

    func setupCell(withArticle article: DemoArticle) -> ProductCollectionViewCell {
        self.article = article
        self.backgroundColor = .white
        self.productNameLabel.text = article.brand.name
        thumbImageView.image = nil
        if let imageURL = article.imageThumbURL {
            Nuke.loadImage(with: imageURL, into: thumbImageView)
        }
        self.buyNowButton.accessibilityIdentifier = "buy-now"

        return self
    }

    @IBAction func buyNowButtonTapped(_ sender: AnyObject) {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController, let article = self.article else { return }
        AtlasUI.presentCheckout(onViewController: rootController, forSKU: article.id)
    }
}
