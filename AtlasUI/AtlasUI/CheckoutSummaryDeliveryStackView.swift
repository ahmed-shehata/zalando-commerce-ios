//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryDeliveryStackView: UIStackView {

    internal let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        label.textAlignment = .Left
        return label
    }()

    internal let deliveryValueLabel: UILabel = {
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

    typealias T = CheckoutViewModel

    func configureData(viewModel: T) {
        guard let delivery = viewModel.checkout?.delivery else {
            deliveryTitleLabel.text = ""
            deliveryValueLabel.text = ""
            return
        }

        deliveryTitleLabel.text = UILocalizer.string("estimated.delivery.title")

        if let earliest = delivery.earliest,
            earliestDateFormatted = UILocalizer.date(earliest),
            latestDateFormatted = UILocalizer.date(delivery.latest) {
                deliveryValueLabel.text = earliestDateFormatted + " - " + latestDateFormatted
        } else {
                deliveryValueLabel.text = UILocalizer.date(delivery.latest)
        }
    }

}
