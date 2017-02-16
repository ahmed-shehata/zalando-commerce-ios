//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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
            try AppSetup.atlas?.presentCheckout(onViewController: rootController, forSKU: article.id) { [weak self] result in
                switch result {
                case .orderPlaced: print("AtlasUI Finished with: Order Placed")
                case .orderPlacedAndRecommendedItemChosen(let sku): self?.displayRecommendedProduct(sku: sku)
                case .userCancelled: print("AtlasUI Finished with: User Cancelled")
                case .errorDisplayed(let error): print("AtlasUI Finished with: Error Displayed(\(error))")
                }
            }
        } catch let error {
            print("Cannot present checkout", error)
        }
    }

    func displayRecommendedProduct(sku: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard
                let catalogVC = CatalogViewController.shared,
                let pdpVC = catalogVC.storyboard?.instantiateViewController(withIdentifier: "PDP") as? PDPViewController else { return }

            pdpVC.sku = sku
            catalogVC.navigationController?.pushViewController(pdpVC, animated: true)
        }
    }

}
