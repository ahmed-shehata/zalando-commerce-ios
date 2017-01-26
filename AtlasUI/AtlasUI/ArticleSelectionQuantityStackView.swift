//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

struct ArticleSelectionQuantityViewModel {

    let currentValue: Int
    let maximumValue: Int

}

class ArticleSelectionQuantityStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = Localizer.format(string: "selectionView.title.quantity")
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.tintColor = .gray
        return stepper
    }()

}

extension ArticleSelectionQuantityStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(stepper)
        addArrangedSubview(valueLabel)
    }

    func configureConstraints() {
        valueLabel.setWidth(equalToConstant: 30)
        stepper.setWidth(equalToConstant: 100)
    }

}

extension ArticleSelectionQuantityStackView: UIDataBuilder {

    typealias T = ArticleSelectionQuantityViewModel

    func configure(viewModel: ArticleSelectionQuantityViewModel) {
        stepper.alpha = viewModel.maximumValue == 1 ? 0.2 : 1
        stepper.value = Double(viewModel.currentValue)
        stepper.maximumValue = Double(viewModel.maximumValue)
        valueLabel.text = "\(viewModel.currentValue)"
    }

}
