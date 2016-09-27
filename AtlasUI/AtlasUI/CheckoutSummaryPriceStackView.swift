//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryPriceStackView: UIStackView {

    internal let shippingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        return stackView
    }()

    internal let shippingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Left
        return label
    }()

    internal let shippingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

    private let dummySeparator1Label: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(4)
        label.text = " "
        return label
    }()

    internal let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        return stackView
    }()

    internal let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        label.textAlignment = .Left
        return label
    }()

    internal let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        label.textAlignment = .Right
        return label
    }()

    internal let vatTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

    private let dummySeparator2Label: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(6)
        label.text = " "
        return label
    }()

    internal let deliveryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Center
        return label
    }()

    internal let deliveryValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(10, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        label.textAlignment = .Center
        return label
    }()

}

extension CheckoutSummaryPriceStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(shippingStackView)
        addArrangedSubview(dummySeparator1Label)
        addArrangedSubview(totalStackView)
        addArrangedSubview(vatTitleLabel)
        addArrangedSubview(dummySeparator2Label)
        addArrangedSubview(deliveryTitleLabel)
        addArrangedSubview(deliveryValueLabel)

        shippingStackView.addArrangedSubview(shippingTitleLabel)
        shippingStackView.addArrangedSubview(shippingValueLabel)

        totalStackView.addArrangedSubview(totalTitleLabel)
        totalStackView.addArrangedSubview(totalValueLabel)
    }

}

extension CheckoutSummaryPriceStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        shippingTitleLabel.text = viewModel.loc("Shipping")
        shippingValueLabel.text = viewModel.localizer.fmtPrice(viewModel.checkoutViewModel.shippingPriceValue)
        totalTitleLabel.text = viewModel.loc("Total")
        totalValueLabel.text = viewModel.localizer.fmtPrice(viewModel.checkoutViewModel.totalPriceValue)
        vatTitleLabel.text = viewModel.loc("vat.included")

        formatDeliveryDates(viewModel)
    }

    private func formatDeliveryDates(viewModel: T) {
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
