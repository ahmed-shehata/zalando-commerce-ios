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

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizer.format(string: "summaryView.label.coupon.placeholder")
        textField.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        textField.textColor = UIColor(hex: 0x7F7F7F)
        textField.returnKeyType = .send
        textField.autocapitalizationType = .allCharacters
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        return textField
    }()

    let clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "tableClose", bundledWith: AddressCheckRowView.self), for: .normal)
        return button
    }()

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
