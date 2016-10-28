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
        self.backgroundColor = .whiteColor()
        self.productNameLabel.text = article.brand.name
        thumbImageView.image = nil
        if let imageUrl = article.imageThumbURL {
            thumbImageView.nk_setImageWith(imageUrl)
        }
        self.buyNowButton.accessibilityIdentifier = "buy-now"

        return self
    }

    @IBAction func buyNowButtonTapped(sender: AnyObject) {
        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController, article = self.article {
            AppSetup.checkout?.presentCheckout(onViewController: rootController, forProductSKU: article.id)
        }
    }
}
