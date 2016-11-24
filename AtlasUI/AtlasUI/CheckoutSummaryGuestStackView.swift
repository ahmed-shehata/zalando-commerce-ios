//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class CheckoutSummaryGuestStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.text = Localizer.string("summaryView.label.guestCheckout")
        label.textColor = .blackColor()
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

}

extension CheckoutSummaryGuestStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }

}

extension CheckoutSummaryGuestStackView: UIDataBuilder {

    typealias T = String?

    func configureData(viewModel: T) {
        valueLabel.text = viewModel
    }

}
