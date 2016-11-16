//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryDeliveryStackView: UIStackView {

    let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        label.textAlignment = .Left
        return label
    }()

    let deliveryValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Right
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

    func configureData(viewModel: T) {
        guard let delivery = viewModel.delivery else {
            deliveryTitleLabel.text = ""
            deliveryValueLabel.text = ""
            return
        }

        deliveryTitleLabel.text = Localizer.string("summaryView.label.estimatedDelivery")

        if let earliest = delivery.earliest,
            earliestDateFormatted = Localizer.date(earliest),
            latestDateFormatted = Localizer.date(delivery.latest) {
                deliveryValueLabel.text = earliestDateFormatted + " - " + latestDateFormatted
        } else {
                deliveryValueLabel.text = Localizer.date(delivery.latest)
        }
    }

}
