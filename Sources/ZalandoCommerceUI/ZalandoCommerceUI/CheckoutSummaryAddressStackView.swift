//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

struct CheckoutSummaryAddressViewModel {
    let addressLines: [String]
    let showArrow: Bool
}

class CheckoutSummaryAddressStackView: UIStackView, RowStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let linesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()

    let firstLineValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    let secondLineValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        return label
    }()

    let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryAddressStackView.self))
        imageView.contentMode = .center
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

    func configure(viewModel: T) {
        firstLineValueLabel.text = viewModel.addressLines[0].trimmed()
        secondLineValueLabel.text = viewModel.addressLines.count > 1 ? viewModel.addressLines[1].trimmed() : nil
        arrowImageView.alpha = viewModel.showArrow ? 1 : 0
    }

}
