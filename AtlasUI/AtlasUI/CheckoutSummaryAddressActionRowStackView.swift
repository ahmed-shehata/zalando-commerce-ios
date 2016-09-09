//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct CheckoutSummaryAddressActionViewModel {
    let title: String
    let firstLineValue: String
    let secondLineValue: String?
    let showArrow: Bool
}

class CheckoutSummaryAddressActionRowStackView: UIStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()

    internal let linesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2
        return stackView
    }()

    internal let firstLineValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .ByTruncatingTail
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    internal let secondLineValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .ByTruncatingTail
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    internal let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryAddressActionRowStackView.self))
        imageView.contentMode = .Center
        return imageView
    }()

}

extension CheckoutSummaryAddressActionRowStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(linesStackView)
        linesStackView.addArrangedSubview(firstLineValueLabel)
        linesStackView.addArrangedSubview(secondLineValueLabel)
        addArrangedSubview(arrowImageView)
    }

    func configureConstraints() {
        titleLabel.setWidth(equalToView: linesStackView)
        arrowImageView.setWidth(equalToConstant: 20)
    }

}

extension CheckoutSummaryAddressActionRowStackView: UIDataBuilder {

    typealias T = CheckoutSummaryAddressActionViewModel

    func configureData(viewModel: T) {
        titleLabel.text = viewModel.title
        firstLineValueLabel.text = viewModel.firstLineValue
        secondLineValueLabel.text = viewModel.secondLineValue
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
