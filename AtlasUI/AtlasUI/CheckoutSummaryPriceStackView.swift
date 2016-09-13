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
        label.textAlignment = .Right
        return label
    }()

    internal let shippingValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .Right
        return label
    }()

    private let dummySeparatorLabel: UILabel = {
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
        label.textAlignment = .Right
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
        label.textAlignment = .Center
        return label
    }()
    internal let deliveryLabel: UILabel = {
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
        addArrangedSubview(dummySeparatorLabel)
        addArrangedSubview(totalStackView)
        addArrangedSubview(vatTitleLabel)
        addArrangedSubview(deliveryLabel)

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
        let estimatedDelivery = viewModel.loc("estimated.delivery") + ": "
        var datesString = ""
        if let earliest = viewModel.checkoutViewModel.checkout?.delivery.earliest, earliestString = viewModel.localizer.fmtDate(earliest)
        where viewModel.checkoutViewModel.checkout?.delivery.earliest != viewModel.checkoutViewModel.checkout?.delivery.latest {
            datesString += earliestString + " - "
        }
        if let latest = viewModel.checkoutViewModel.checkout?.delivery.latest,
            latestString = viewModel.localizer.fmtDate(latest) {
                datesString += latestString
        }

        deliveryLabel.text = datesString.isEmpty ? "" : estimatedDelivery + datesString
    }

}
