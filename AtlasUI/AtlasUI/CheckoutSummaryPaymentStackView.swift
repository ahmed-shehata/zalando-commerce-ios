//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct CheckoutSummaryPaymentViewModel {

    let value: String
    let showArrow: Bool

}

class CheckoutSummaryPaymentStackView: UIStackView, RowStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()

    internal let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .ByTruncatingTail
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    internal let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryPaymentStackView.self))
        imageView.contentMode = .Center
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

    func configureData(viewModel: T) {
        valueLabel.text = viewModel.value
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
