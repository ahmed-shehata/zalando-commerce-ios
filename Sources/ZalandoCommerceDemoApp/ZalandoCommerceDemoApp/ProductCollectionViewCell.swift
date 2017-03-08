//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import ZalandoCommerceAPI
import ZalandoCommerceUI
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
        let sku = ConfigSKU(value: article.id)
        AppSetup.zCommerceUI?.presentCheckout(onViewController: rootController, for: sku) { [weak self] result in
            if case let .orderPlaced(_, recommendedProductSKU) = result, let sku = recommendedProductSKU {
                self?.displayRecommendedProduct(sku: sku)
            }
        }
    }

    func displayRecommendedProduct(sku: ConfigSKU) {
        guard
            let catalogVC = CatalogViewController.shared,
            let pdpVC = catalogVC.storyboard?.instantiateViewController(withIdentifier: "PDP") as? PDPViewController else { return }

        pdpVC.sku = sku
        catalogVC.navigationController?.pushViewController(pdpVC, animated: true)
    }

}
