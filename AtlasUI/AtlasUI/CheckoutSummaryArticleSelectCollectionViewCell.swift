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

    func configure(selectedArticle: SelectedArticle, type: CheckoutSummaryArticleRefineType, idx: Int) {
        let isSelected = type.idx(selectedArticle: selectedArticle) == idx

        switch type {
        case .size:
            let unit = selectedArticle.article.availableUnits[idx]
            valueLabel.text = unit.size
            priceLabel.attributedText = priceAttributedString(price: unit.price, originalPrice: unit.originalPrice, isSelected: isSelected)
        case .quantity:
            let currency = selectedArticle.price.currency
            let totalPrice = Money(amount: selectedArticle.price.amount * Decimal(idx + 1), currency: currency)
            let totalOriginalPrice = Money(amount: selectedArticle.unit.originalPrice.amount * Decimal(idx + 1), currency: currency)
            valueLabel.text = "\(idx + 1)"
            priceLabel.attributedText = priceAttributedString(price: totalPrice, originalPrice: totalOriginalPrice, isSelected: isSelected)
        }

        container.borderColor = isSelected ? .orange : UIColor(hex: 0xE5E5E5)
        container.backgroundColor = isSelected ? .orange : .white
        valueLabel.textColor = isSelected ? .white : UIColor(hex: 0x848484)
    }

    private func priceAttributedString(price: Money, originalPrice: Money, isSelected: Bool) -> NSAttributedString {
        guard price.amount != originalPrice.amount else { return priceAttributedString(price: price, isSelected: isSelected) }

        let attributedString = NSMutableAttributedString(attributedString: priceAttributedString(price: price, isSelected: isSelected))
        attributedString.append(separatorAttributedString(isSelected: isSelected))
        attributedString.append(originalPriceAttributedString(originalPrice: originalPrice, isSelected: isSelected))
        return attributedString
    }

    private func priceAttributedString(price: Money, isSelected: Bool) -> NSAttributedString {
        let text = Localizer.format(price: price) ?? ""
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightLight),
                                                             NSForegroundColorAttributeName: isSelected ? .white : UIColor.black])
    }

    private func separatorAttributedString(isSelected: Bool) -> NSAttributedString {
        return NSAttributedString(string: " ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8, weight: UIFontWeightLight),
                                                              NSForegroundColorAttributeName: isSelected ? .white : UIColor.black])
    }

    private func originalPriceAttributedString(originalPrice: Money, isSelected: Bool) -> NSAttributedString {
        let text = Localizer.format(price: originalPrice) ?? ""
        return NSAttributedString(string: text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8, weight: UIFontWeightLight),
                                                             NSForegroundColorAttributeName: isSelected ? .white : UIColor.red,
                                                             NSStrikethroughStyleAttributeName: 1,
                                                             NSStrikethroughColorAttributeName: isSelected ? .white : UIColor.gray])
    }

}
