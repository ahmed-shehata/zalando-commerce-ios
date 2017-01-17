//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class NormalizedAddressStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Localizer.format(string: "addressNormalizedView.title")
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let yourAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n" + Localizer.format(string: "addressNormalizedView.yourAddress")
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let yourAddressLabel: UILabel = {
        let label = RoundedLabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        label.cornerRadius = 15
        label.borderColor = UIColor(hex: 0xE5E5E5)
        label.borderWidth = 1 / UIScreen.main.scale
        return label
    }()

    let suggestedAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n" + Localizer.format(string: "addressNormalizedView.suggestedAddress")
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let suggestedAddressLabel: UILabel = {
        let label = RoundedLabel()
        label.numberOfLines = 0
        label.text = "Hani"
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        label.cornerRadius = 15
        label.borderColor = UIColor(hex: 0xE5E5E5)
        label.borderWidth = 1 / UIScreen.main.scale
        return label
    }()

}

extension NormalizedAddressStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(yourAddressTitleLabel)
        addArrangedSubview(yourAddressLabel)
        addArrangedSubview(suggestedAddressTitleLabel)
        addArrangedSubview(suggestedAddressLabel)
    }

}

extension NormalizedAddressStackView: UIDataBuilder {

    typealias T = (userAddress: CheckAddress, normalizedAddress: CheckAddress)

    func configure(viewModel: (userAddress: CheckAddress, normalizedAddress: CheckAddress)) {
        yourAddressLabel.text = viewModel.userAddress.stringValue
        suggestedAddressLabel.text = viewModel.normalizedAddress.stringValue
    }
}

fileprivate extension CheckAddress {

    var stringValue: String {
        let values = [street, additional, zip, city, Localizer.countryName(forCountryCode: countryCode)]
        return values.flatMap { $0 }.joined(separator: "\n")
    }

}
