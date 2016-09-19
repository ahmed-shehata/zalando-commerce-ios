//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK
import AtlasUI
import AlamofireImage

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    var article: DemoArticle?

    func setupCell(withArticle article: DemoArticle) {
        self.article = article
        self.backgroundColor = .whiteColor()
        self.productNameLabel.text = article.brand.name
        if let imageUrl = article.imageThumbURL {
            self.thumbImageView.af_setImageWithURL(imageUrl)
        }
        self.buyNowButton.accessibilityIdentifier = "buy-now"
    }

    @IBAction func buyNowButtonTapped(sender: AnyObject) {
        if let article = self.article {
            AppSetup.sharedInstance.checkout?.presentCheckout(forProductSKU: article.id)
        }
    }
}
