//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let error: String?
    let nextTextField: TextFieldInputStackView?
}

class TextFieldInputStackView: UIStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x9D9D9D)
        return label
    }()

    internal let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFontOfSize(16, weight: UIFontWeightLight)
        textField.textColor = UIColor(hex: 0x1C1C1C)
        return textField
    }()

    internal let separatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = .blackColor()
        return view
    }()

    internal let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(12)
        label.textColor = .redColor()
        return label
    }()

    weak var nextTextField: TextFieldInputStackView?

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
        layoutMargins = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16)
        layoutMarginsRelativeArrangement = true
        addGestureRecognizer(UITapGestureRecognizer(target: textField, action: #selector(becomeFirstResponder)))
    }

    private func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldValueChanged), forControlEvents: .EditingChanged)
        textField.delegate = self
    }

}

extension TextFieldInputStackView: UIDataBuilder {

    typealias T = TextFieldInputViewModel

    func configureData(viewModel: T) {
        self.nextTextField = viewModel.nextTextField
        textField.returnKeyType = nextTextField == nil ? .Default : .Next
        textField.text = viewModel.value
        textField.placeholder = viewModel.title
        errorLabel.text = viewModel.error ?? " "
        configureTitleLabel()
    }

    private func configureTitleLabel() {
        titleLabel.text = textField.text?.length > 0 ? textField.placeholder : " "
    }

}

extension TextFieldInputStackView: UITextFieldDelegate {

    func textFieldValueChanged() {
        configureTitleLabel()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        separatorView.borderColor = UIColor(hex: 0xFB5108)
        titleLabel.textColor = UIColor(hex: 0xFB5108)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        separatorView.borderColor = .blackColor()
        titleLabel.textColor = UIColor(hex: 0x9D9D9D)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        nextTextField?.textField.becomeFirstResponder()
        return true
    }

}
