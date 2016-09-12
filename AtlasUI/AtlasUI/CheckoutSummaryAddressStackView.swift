//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct CheckoutSummaryAddressViewModel {
    let title: String
    let addressLines: [String]
    let showArrow: Bool
}

class CheckoutSummaryAddressStackView: UIStackView {

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
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryAddressStackView.self))
        imageView.contentMode = .Center
        return imageView
    }()

}

extension CheckoutSummaryAddressStackView: UIBuilder {

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

extension CheckoutSummaryAddressStackView: UIDataBuilder {

    typealias T = CheckoutSummaryAddressViewModel

    func configureData(viewModel: T) {
        titleLabel.text = viewModel.title
        firstLineValueLabel.text = viewModel.addressLines[0].trimmed
        secondLineValueLabel.text = viewModel.addressLines.count > 1 ? viewModel.addressLines[1].trimmed : nil
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
