//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class TextFieldInputStackView: UIStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.alpha = 0
        label.font = .systemFontOfSize(11)
        label.textColor = UIColor(hex: 0xADADAD)
        return label
    }()

    internal let textField: ActionTextField = {
        let textField = ActionTextField()
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

    private weak var nextTextField: TextFieldInputStackView?
    private var valueChangedHandler: TextFieldChangedHandler?

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
        textField.userInteractionEnabled = viewModel.isActive
        textField.inputView = viewModel.customInputView
        if viewModel.customInputView != nil {
            textField.tintColor = .clearColor()
            textField.canCopy = false
            textField.canPaste = false
        }

        errorLabel.text = viewModel.error ?? " "
        valueChangedHandler = viewModel.valueChangedHandler

        configureTitleLabel()
    }

    private func configureTitleLabel() {
        UIView.animateWithDuration(0.3) {
            self.titleLabel.alpha = self.textField.text?.isEmpty == true ? 0 : 1
        }
    }

}

extension TextFieldInputStackView: UITextFieldDelegate {

    func textFieldValueChanged() {
        configureTitleLabel()
        valueChangedHandler?(textField.text)
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
        if let nextTextField = nextTextField {
            nextTextField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}