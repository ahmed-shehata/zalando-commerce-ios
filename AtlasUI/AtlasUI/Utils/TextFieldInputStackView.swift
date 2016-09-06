//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let placeholder: String?
}

class TextFieldInputStackView: UIStackView {

    internal let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14)
        label.textColor = .blackColor()
        return label
    }()

    internal let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        textField.textColor = UIColor(hex: 0x444444)
        return textField
    }()

    internal let separatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.leadingMargin = 15
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    convenience init() {
        self.init(arrangedSubviews: [])
        axis = .Vertical
    }

}

extension TextFieldInputStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(stackView)
        addArrangedSubview(separatorView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
    }

    func configureConstraints() {
        titleLabel.setWidth(equalToConstant: 100)
        separatorView.setHeight(equalToConstant: 1)
    }

}

extension TextFieldInputStackView: UIDataBuilder {

    typealias T = TextFieldInputViewModel

    func configureData(viewModel: T) {
        titleLabel.text = viewModel.title
        textField.text = viewModel.value
        textField.placeholder = viewModel.placeholder
    }

}
