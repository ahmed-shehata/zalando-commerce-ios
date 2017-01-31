//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryArticleSelectCollectionViewCell: UICollectionViewCell {

    let container: RoundedView = {
        let view = RoundedView()
        view.borderColor = UIColor(hex: 0xE5E5E5)
        view.borderWidth = UIView.onePixel
        view.cornerRadius = 5
        return view
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x848484)
        label.textAlignment = .center
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

}

extension CheckoutSummaryArticleSelectCollectionViewCell: UIBuilder {

    func configureView() {
        addSubview(container)
        container.addSubview(stackView)

        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(priceLabel)
    }

    func configureConstraints() {
        container.fillInSuperview()
        stackView.fillInSuperview()
    }

}

extension CheckoutSummaryArticleSelectCollectionViewCell {

    func configure(selectedArticle: SelectedArticle, type: CheckoutSummaryArticleSelectCollectionViewType, idx: Int) {
        let isSelected: Bool

        switch type {
        case .size:
            let currentItem = selectedArticle.article.availableUnits[idx]
            valueLabel.text = currentItem.size
            priceLabel.attributedText = priceAttributedString(price: currentItem.price, originalPrice: currentItem.originalPrice)
            isSelected = idx == selectedArticle.unitIndex
        case .quantity:
            let currency = selectedArticle.price.currency
            let totalPrice = Money(amount: selectedArticle.price.amount * Decimal(idx + 1), currency: currency)
            let totalOriginalPrice = Money(amount: selectedArticle.unit.originalPrice.amount * Decimal(idx + 1), currency: currency)
            valueLabel.text = "\(idx + 1)"
            priceLabel.attributedText = priceAttributedString(price: totalPrice, originalPrice: totalOriginalPrice)
            isSelected = idx == selectedArticle.quantity - 1
        }

        container.borderColor = isSelected ? .orange : UIColor(hex: 0xE5E5E5)
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: isSelected ? UIFontWeightBold : UIFontWeightLight)
    }

    private func priceAttributedString(price: Money, originalPrice: Money) -> NSAttributedString {
        guard price.amount != originalPrice.amount else { return priceAttributedString(price: price) }

        let attributedString = NSMutableAttributedString(attributedString: priceAttributedString(price: price))
        attributedString.append(separatorAttributedString())
        attributedString.append(originalPriceAttributedString(originalPrice: originalPrice))
        return attributedString
    }

    private func priceAttributedString(price: Money) -> NSAttributedString {
        let text = Localizer.format(price: price) ?? ""
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight),
                                                             NSForegroundColorAttributeName: UIColor.black])
    }

    private func separatorAttributedString() -> NSAttributedString {
        return NSAttributedString(string: " ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8, weight: UIFontWeightLight),
                                                              NSForegroundColorAttributeName: UIColor.black])
    }

    private func originalPriceAttributedString(originalPrice: Money) -> NSAttributedString {
        let text = Localizer.format(price: originalPrice) ?? ""
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8, weight: UIFontWeightLight),
                                                             NSForegroundColorAttributeName: UIColor.red,
                                                             NSStrikethroughStyleAttributeName: 1,
                                                             NSStrikethroughColorAttributeName: UIColor.gray])
    }

}
