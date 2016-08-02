//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

final class PaymentSummaryRow: UIView {

    private let priceFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "es_ES")
        formatter.numberStyle = .CurrencyStyle
        return formatter
    }()

    var shippingPrice: Float = 0
    private var itemPrice: Article.Price

    var totalPrice: Float {
        return shippingPrice + itemPrice.amount
    }

    private let totalPriceTitleLabel = UILabel()
    private let bottomSeparatorView = UIView()
    private let shippingTitleLabel = UILabel()
    private let shippingPriceLabel = UILabel()
    private let itemPriceLabel = UILabel()

    override func willMoveToSuperview(newSuperview: UIView?) {
        guard let _ = newSuperview else { return }

        self.backgroundColor = UIColor.clearColor()

        self.addSubview(shippingPriceLabel)
        self.addSubview(itemPriceLabel)
        self.addSubview(totalPriceTitleLabel)
        self.addSubview(shippingTitleLabel)
        self.addSubview(bottomSeparatorView)

        self.setupTotalPriceTitleLabel()
        self.setupBottomSeparatorView()
        self.setupShippingTitleLabel()
        self.setupShippingPriceLabel()
        self.setupItemPriceLabel()
    }

    init(shippingAmount: Float, itemPrice: Article.Price) {
        self.shippingPrice = shippingAmount
        self.itemPrice = itemPrice
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupTotalPriceTitleLabel() {
        totalPriceTitleLabel.text = "Total".loc
        totalPriceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceTitleLabel.font = totalPriceTitleLabel.font.fontWithSize(18)
        totalPriceTitleLabel.textColor = UIColor.grayColor()
        totalPriceTitleLabel.heightAnchor.constraintEqualToConstant(20).active = true
        totalPriceTitleLabel.topAnchor.constraintEqualToAnchor(shippingTitleLabel.bottomAnchor, constant: 15).active = true
        totalPriceTitleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 110).active = true
    }

    private func setupBottomSeparatorView() {
        bottomSeparatorView.layer.borderWidth = 5
        bottomSeparatorView.layer.borderColor = UIColor.blackColor().CGColor
        bottomSeparatorView.alpha = 0.2
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 0.95).active = true
        bottomSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        bottomSeparatorView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        bottomSeparatorView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
    }

    private func setupShippingTitleLabel() {
        shippingTitleLabel.text = "Shipping".loc
        shippingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        shippingTitleLabel.font = shippingTitleLabel.font.fontWithSize(13)
        shippingTitleLabel.textColor = UIColor.grayColor()
        shippingTitleLabel.heightAnchor.constraintEqualToConstant(10).active = true
        shippingTitleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        shippingTitleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 110).active = true
    }

    private func setupShippingPriceLabel() {
        shippingPriceLabel.text = priceFormatter.stringFromNumber(shippingPrice)
        shippingPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        shippingPriceLabel.text = shippingPriceLabel.text?.uppercaseString
        shippingPriceLabel.font = shippingPriceLabel.font.fontWithSize(13)
        shippingPriceLabel.textColor = UIColor.blackColor()
        shippingPriceLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -10).active = true
        shippingPriceLabel.heightAnchor.constraintEqualToConstant(10).active = true
        shippingPriceLabel.topAnchor.constraintEqualToAnchor(shippingTitleLabel.topAnchor).active = true
    }

    private func setupItemPriceLabel() {
        itemPriceLabel.text = priceFormatter.stringFromNumber(totalPrice)
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.text = itemPriceLabel.text?.uppercaseString
        itemPriceLabel.font = itemPriceLabel.font.fontWithSize(18)
        itemPriceLabel.textColor = UIColor.blackColor()
        itemPriceLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -10).active = true
        itemPriceLabel.heightAnchor.constraintEqualToConstant(20).active = true
        itemPriceLabel.topAnchor.constraintEqualToAnchor(totalPriceTitleLabel.topAnchor).active = true
    }

}
