//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryCouponStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = Localizer.format(string: "summaryView.label.coupon.title")
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizer.format(string: "summaryView.label.coupon.placeholder")
        textField.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        textField.textColor = UIColor(hex: 0x7F7F7F)
        textField.returnKeyType = .send
        textField.autocapitalizationType = .allCharacters
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()

    let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tableClose", bundledWith: AddressCheckRowView.self), for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()

    var couponUpdatedHandler: ((String?) -> Void)?

    dynamic private func clearButtonTapped() {
        couponUpdatedHandler?(nil)
        textField.becomeFirstResponder()
    }

}

extension CheckoutSummaryCouponStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(clearButton)
    }

    func configureConstraints() {
        titleLabel.setWidth(equalToView: textField)
        clearButton.setWidth(equalToConstant: 20)
    }

}

extension CheckoutSummaryCouponStackView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isEmpty = textField.text?.trimmed().length == 0
        couponUpdatedHandler?(isEmpty ? nil : textField.text)
        textField.resignFirstResponder()
        return true
    }

}
