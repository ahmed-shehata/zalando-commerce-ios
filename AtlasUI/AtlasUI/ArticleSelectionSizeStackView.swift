//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

struct ArticleSelectionSizeViewModel {

    let value: String
    let showArrow: Bool

}

class ArticleSelectionSizeStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = Localizer.format(string: "selectionView.title.size")
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryPaymentStackView.self))
        imageView.contentMode = .center
        return imageView
    }()

}

extension ArticleSelectionSizeStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
        addArrangedSubview(arrowImageView)
    }

    func configureConstraints() {
        titleLabel.setWidth(equalToView: valueLabel)
        arrowImageView.setWidth(equalToConstant: 20)
    }

}

extension ArticleSelectionSizeStackView: UIDataBuilder {

    typealias T = ArticleSelectionSizeViewModel

    func configure(viewModel: T) {
        valueLabel.text = viewModel.value
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
