//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryDeliveryStackView: UIStackView {

    let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let deliveryValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

}

extension CheckoutSummaryDeliveryStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(deliveryTitleLabel)
        addArrangedSubview(deliveryValueLabel)
    }

    func configureConstraints() {
        deliveryTitleLabel.setWidth(equalToView: deliveryValueLabel)
    }

}

extension CheckoutSummaryDeliveryStackView: UIDataBuilder {

    typealias T = CheckoutSummaryDataModel

    func configure(viewModel: T) {
        guard let delivery = viewModel.delivery else {
            deliveryTitleLabel.text = ""
            deliveryValueLabel.text = ""
            return
        }

        deliveryTitleLabel.text = Localizer.string("summaryView.label.estimatedDelivery")

        guard let earliest = delivery.earliest,
            let earliestDateFormatted = Localizer.date(earliest),
            let latestDateFormatted = Localizer.date(delivery.latest) else {
                deliveryValueLabel.text = Localizer.date(delivery.latest)
                return
        }

        deliveryValueLabel.text = earliestDateFormatted + " - " + latestDateFormatted
    }

}
