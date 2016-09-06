//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let error: String?
}

class TextFieldInputStackView: UIStackView {

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
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    internal let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(10)
        label.textColor = .redColor()
        return label
    }()

}

extension TextFieldInputStackView: UIBuilder {

    func configureView() {
        configureThisView()
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(separatorView)
        addArrangedSubview(errorLabel)
        configureTextField()
    }

    func configureConstraints() {
        separatorView.setHeight(equalToConstant: 1)
    }

    private func configureThisView() {
        axis = .Vertical
        spacing = 2
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layoutMarginsRelativeArrangement = true
    }

    private func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .ValueChanged)
    }

}

extension TextFieldInputStackView: UIDataBuilder {

    typealias T = TextFieldInputViewModel

    func configureData(viewModel: T) {
        textField.text = viewModel.value
        textField.placeholder = viewModel.title
        errorLabel.text = viewModel.error
        configureTitleLabel()
    }

    private func configureTitleLabel() {
        titleLabel.text = textField.text?.length > 0 ? textField.placeholder : ""
    }

}

extension TextFieldInputStackView {

    func textFieldValueChanged() {
        configureTitleLabel()
    }

}
