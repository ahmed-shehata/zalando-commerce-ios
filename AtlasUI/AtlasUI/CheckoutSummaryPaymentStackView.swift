//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct CheckoutSummaryPaymentViewModel {

    let value: String
    let showArrow: Bool

}

class CheckoutSummaryPaymentStackView: UIStackView, RowStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
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

extension CheckoutSummaryPaymentStackView: UIBuilder {

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

extension CheckoutSummaryPaymentStackView: UIDataBuilder {

    typealias T = CheckoutSummaryPaymentViewModel

    func configure(viewModel: T) {
        valueLabel.text = viewModel.value
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
