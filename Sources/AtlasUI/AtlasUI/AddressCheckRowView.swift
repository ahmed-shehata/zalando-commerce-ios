//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AddressCheckRowView: RoundedView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let roundIndicatorContainer: UIView = UIView()

    let roundIndicator: RoundedView = {
        let view = RoundedView()
        view.isCircle = true
        view.borderColor = .lightGray
        view.borderWidth = UIView.onePixel
        view.backgroundColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: UIFontWeightLight)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()

    let selectButton: AddressCheckRowButton = AddressCheckRowButton(type: .custom)

    let editButtonContainer: UIView = UIView()

    let editButton: AddressCheckRowButton = {
        let button = AddressCheckRowButton(type: .custom)
        button.setImage(UIImage(named: "pen", bundledWith: AddressCheckRowView.self), for: .normal)
        return button
    }()

    func selectRow(selected: Bool) {
        borderColor = selected ? .orange : UIColor(hex: 0xE5E5E5)
        roundIndicator.borderColor = selected ? .orange : .lightGray
        editButton.setImage(UIImage(named: selected ? "pen-selected" : "pen", bundledWith: AddressCheckRowView.self), for: .normal)
    }

}

extension AddressCheckRowView: UIBuilder {

    func configureView() {
        cornerRadius = 5
        borderWidth = UIView.onePixel
        borderColor = UIColor(hex: 0xE5E5E5)

        addSubview(stackView)
        addSubview(selectButton)

        stackView.addArrangedSubview(roundIndicatorContainer)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(editButtonContainer)

        roundIndicatorContainer.addSubview(roundIndicator)
        editButtonContainer.addSubview(editButton)
    }

    func configureConstraints() {
        stackView.fillInSuperview()

        roundIndicator.centerVerticallyInSuperview()
        roundIndicator.setSquareAspectRatio()
        roundIndicator.setWidth(equalToConstant: 10)
        roundIndicator.snap(toSuperview: .right, constant: -5)
        roundIndicator.snap(toSuperview: .left, constant: 10)

        editButton.centerVerticallyInSuperview()
        editButton.setSquareAspectRatio()
        editButton.setWidth(equalToConstant: 30)
        editButton.snap(toSuperview: .right, constant: -10)
        editButton.snap(toSuperview: .left, constant: 10)

        selectButton.snap(toSuperview: .top)
        selectButton.snap(toSuperview: .right, constant: -50)
        selectButton.snap(toSuperview: .bottom)
        selectButton.snap(toSuperview: .left)
    }

}

extension AddressCheckRowView: UIDataBuilder {

    typealias T = AddressCheck

    func configure(viewModel: AddressCheck) {
        selectButton.address = viewModel
        editButton.address = viewModel
        label.text = viewModel.stringValue
    }

}

fileprivate extension AddressCheck {

    var stringValue: String {
        let values = [street, additional, zip, city, Localizer.countryName(forCountryCode: countryCode)]
        return values.flatMap { $0 }.joined(separator: "\n")
    }

}
