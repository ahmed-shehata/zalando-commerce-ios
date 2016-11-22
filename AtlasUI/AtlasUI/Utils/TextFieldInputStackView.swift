//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class TextFieldInputStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.alpha = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = UIColor(hex: 0xADADAD)
        return label
    }()

    let textField: ActionTextField = {
        let textField = ActionTextField()
        textField.font = .systemFont(ofSize: 15)
        textField.textColor = UIColor(hex: 0x333333)
        return textField
    }()

    let separatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = .black
        return view
    }()

    let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = UIColor(hex: 0xDB2D2D)
        label.text = " "
        return label
    }()

    fileprivate weak var nextTextField: TextFieldInputStackView?
    fileprivate var valueChangedHandler: TextFieldChangedHandler?
    fileprivate var validators: [FormValidator] = []

    @discardableResult
    func validateForm() -> Bool {
        let error = checkFormForError()
        errorLabel.text = error ?? " "
        return error == nil
    }

    fileprivate func checkFormForError() -> String? {
        return validators.flatMap { $0.errorMessage(textField.text) }.first
    }

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

    fileprivate func configureStackView() {
        axis = .vertical
        spacing = 2
        layoutMargins = UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16)
        isLayoutMarginsRelativeArrangement = true
        addGestureRecognizer(UITapGestureRecognizer(target: textField, action: #selector(becomeFirstResponder)))
    }

    fileprivate func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
    }

}

extension TextFieldInputStackView: UIDataBuilder {

    typealias T = TextFieldInputViewModel

    func configure(viewModel: T) {
        titleLabel.text = viewModel.title.uppercased()

        nextTextField = viewModel.nextTextFieldInput
        textField.text = viewModel.value
        textField.accessibilityIdentifier = viewModel.accessibilityIdentifier
        textField.placeholder = viewModel.title
        textField.returnKeyType = nextTextField == nil ? .default : .next

        textField.isUserInteractionEnabled = viewModel.isActive
        if !viewModel.isActive {
            textField.textColor = UIColor(hex: 0xADADAD)
        }

        textField.inputView = viewModel.customInputView
        if viewModel.customInputView != nil {
            textField.tintColor = .clear
            textField.canCopy = false
            textField.canPaste = false
        }

        valueChangedHandler = viewModel.valueChangedHandler
        validators = viewModel.validators

        configureTitleLabel()
    }

    func configureTitleLabel() {
        UIView.animate {
            self.titleLabel.alpha = self.textField.text?.isEmpty == true ? 0 : 1
        }
    }

}

extension TextFieldInputStackView: UITextFieldDelegate {

    func textFieldValueChanged() {
        configureTitleLabel()
        valueChangedHandler?(textField.text)
        if checkFormForError() == nil {
            errorLabel.text = " "
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        separatorView.borderColor = UIColor(hex: 0xFF6900)
        titleLabel.textColor = UIColor(hex: 0xFF6900)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        separatorView.borderColor = .black
        titleLabel.textColor = UIColor(hex: 0xADADAD)
        validateForm()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = nextTextField {
            nextTextField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        validateForm()
        return true
    }

}
