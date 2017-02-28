//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

enum ArticleSelectionCellStyle {

    case normal
    case selected

    var priceFont: UIFont { return .systemFont(ofSize: 10, weight: UIFontWeightLight) }
    var originalPriceFont: UIFont { return .systemFont(ofSize: 8, weight: UIFontWeightLight) }

    var priceColor: UIColor {
        switch self {
        case .normal: return .black
        case .selected: return .white
        }
    }

    var originalPriceColor: UIColor {
        switch self {
        case .normal: return .red
        case .selected: return .white
        }
    }

    var strikethroughColor: UIColor {
        switch self {
        case .normal: return .gray
        case .selected: return .white
        }
    }

    var borderColor: UIColor {
        switch self {
        case .normal: return UIColor(hex: 0xE5E5E5)
        case .selected: return .orange
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .normal: return .white
        case .selected: return .orange
        }
    }

    var valueColor: UIColor {
        switch self {
        case .normal: return UIColor(hex: 0x848484)
        case .selected: return .white
        }
    }

}

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
        let style: ArticleSelectionCellStyle = type.idx(selectedArticle: selectedArticle) == idx ? .selected : .normal

        switch type {
        case .size:
            let unit = selectedArticle.article.availableUnits[idx]
            valueLabel.text = unit.size
            priceLabel.attributedText = priceAttributedString(price: unit.price, originalPrice: unit.originalPrice, style: style)
        case .quantity:
            let selectedQuantity = idx + 1
            valueLabel.text = "\(selectedQuantity)"
            priceLabel.attributedText = priceAttributedString(price: selectedArticle.totalPrice,
                                                              originalPrice: selectedArticle.totalOriginalPrice,
                                                              style: style)
        }

        container.borderColor = style.borderColor
        container.backgroundColor = style.backgroundColor
        valueLabel.textColor = style.valueColor
    }

    private func priceAttributedString(price: Money, originalPrice: Money, style: ArticleSelectionCellStyle) -> NSAttributedString {
        guard price.amount != originalPrice.amount else { return priceAttributedString(price: price, style: style) }

        let attributedString = NSMutableAttributedString(attributedString: priceAttributedString(price: price, style: style))
        attributedString.append(originalPriceAttributedString(originalPrice: originalPrice, style: style))
        return attributedString
    }

    private func priceAttributedString(price: Money, style: ArticleSelectionCellStyle) -> NSAttributedString {
        let text = Localizer.format(price: price) ?? ""
        return text.attributed
            .addFont(font: style.priceFont)
            .addForeground(color: style.priceColor)
    }

    private func originalPriceAttributedString(originalPrice: Money, style: ArticleSelectionCellStyle) -> NSAttributedString {
        let text = " " + (Localizer.format(price: originalPrice) ?? "")
        return text.attributed
            .addFont(font: style.originalPriceFont)
            .addForeground(color: style.originalPriceColor)
            .addStrikethrough(color: style.strikethroughColor)
    }

}
