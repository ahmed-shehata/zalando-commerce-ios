//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let error: String?
    let nextTextFieldInput: TextFieldInputStackView?
}

class TextFieldInputStackView: UIStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.alpha = 0
        label.font = .systemFontOfSize(11)
        label.textColor = UIColor(hex: 0xADADAD)
        return label
    }()

    internal let textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFontOfSize(15)
        textField.textColor = UIColor(hex: 0x333333)
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
        label.font = .systemFontOfSize(11)
        label.textColor = UIColor(hex: 0xDB2D2D)
        return label
    }()

    weak var nextTextField: TextFieldInputStackView?

}

extension TextFieldInputStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(separatorView)
        addArrangedSubview(errorLabel)
        configureStackView()
        configureTextField()
    }

    func configureConstraints() {
        separatorView.setHeight(equalToConstant: 1)
    }

    private func configureStackView() {
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
        titleLabel.text = viewModel.title.uppercaseString

        nextTextField = viewModel.nextTextFieldInput
        textField.text = viewModel.value
        textField.placeholder = viewModel.title
        textField.returnKeyType = nextTextField == nil ? .Default : .Next

        errorLabel.text = viewModel.error ?? " "

        configureTitleLabel()
    }

    private func configureTitleLabel() {
        UIView.animateWithDuration(0.3) {
            self.titleLabel.alpha = self.textField.text?.length > 0 ? 1 : 0
        }
    }

}

extension TextFieldInputStackView: UITextFieldDelegate {

    func textFieldValueChanged() {
        configureTitleLabel()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        separatorView.borderColor = UIColor(hex: 0xFF6900)
        titleLabel.textColor = UIColor(hex: 0xFF6900)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        separatorView.borderColor = .blackColor()
        titleLabel.textColor = UIColor(hex: 0xADADAD)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        nextTextField?.textField.becomeFirstResponder()
        return true
    }

}
