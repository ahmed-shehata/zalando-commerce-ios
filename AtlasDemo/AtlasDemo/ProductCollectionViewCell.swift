//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK
import AtlasUI
import Nuke

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var thumbImageView: UIImageView!
    @IBOutlet fileprivate weak var buyNowButton: UIButton!
    @IBOutlet fileprivate weak var productNameLabel: UILabel!
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
        do {
            try AppSetup.atlas?.presentCheckout(onViewController: rootController, forSKU: article.id)
        } catch let error {
            print("Cannot present checkout", error)
        }
    }
}
