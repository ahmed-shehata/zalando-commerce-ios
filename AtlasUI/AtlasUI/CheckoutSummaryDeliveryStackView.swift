//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryDeliveryStackView: UIStackView {

    private let dummyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(4)
        label.text = " "
        return label
    }()

    internal let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        label.textAlignment = .Left
        return label
    }()

    internal let deliveryIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "truck", bundledWith: CheckoutSummaryDeliveryStackView.self))
        imageView.contentMode = .Center
        return imageView
    }()

    internal let deliveryValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Left
        return label
    }()

}

extension CheckoutSummaryDeliveryStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(dummyLabel)
        addArrangedSubview(deliveryIcon)
        addArrangedSubview(deliveryValueLabel)
    }

    func configureConstraints() {
        dummyLabel.setWidth(equalToView: deliveryValueLabel)
    }

}

extension CheckoutSummaryDeliveryStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        guard let delivery = viewModel.checkoutViewModel.checkout?.delivery else {
            deliveryTitleLabel.text = ""
            deliveryValueLabel.text = ""
            return
        }

        deliveryTitleLabel.text = viewModel.loc("estimated.delivery.title")
        if let
            earliest = delivery.earliest,
            earliestDateFormatted = viewModel.localizer.fmtDate(earliest),
            latestDateFormatted = viewModel.localizer.fmtDate(delivery.latest) {
            deliveryValueLabel.text = earliestDateFormatted + " - " + latestDateFormatted
        } else {
            deliveryValueLabel.text = viewModel.localizer.fmtDate(delivery.latest)
        }
    }

}
