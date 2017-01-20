//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class NormalizedAddressStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = Localizer.format(string: "addressNormalizedView.header")
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .center
        return label
    }()

    let originalAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n" + Localizer.format(string: "addressNormalizedView.originalAddress")
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let originalAddressRowView: NormalizedAddressRowView = {
        let view = NormalizedAddressRowView()
        view.selectButton.addTarget(self, action: #selector(addressRowSelected(button:)), for: .touchUpInside)
        return view
    }()

    let suggestedAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n" + Localizer.format(string: "addressNormalizedView.suggestedAddress")
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let suggestedAddressRowView: NormalizedAddressRowView = {
        let view = NormalizedAddressRowView()
        view.selectButton.addTarget(self, action: #selector(addressRowSelected(button:)), for: .touchUpInside)
        return view
    }()

    var selectedAddress: CheckAddress? {
        didSet {
            originalAddressRowView.selectRow(selected: originalAddressRowView.selectButton.address === selectedAddress)
            suggestedAddressRowView.selectRow(selected: suggestedAddressRowView.selectButton.address === selectedAddress)
        }
    }

    dynamic private func addressRowSelected(button: NormalizedAddressRowButton) {
        selectedAddress = button.address
    }

}

extension NormalizedAddressStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(originalAddressTitleLabel)
        addArrangedSubview(originalAddressRowView)
        addArrangedSubview(suggestedAddressTitleLabel)
        addArrangedSubview(suggestedAddressRowView)
    }

}

extension NormalizedAddressStackView: UIDataBuilder {

    typealias T = (userAddress: CheckAddress, normalizedAddress: CheckAddress)

    func configure(viewModel: (userAddress: CheckAddress, normalizedAddress: CheckAddress)) {
        originalAddressRowView.configure(viewModel: viewModel.userAddress)
        suggestedAddressRowView.configure(viewModel: viewModel.normalizedAddress)
        selectedAddress = viewModel.normalizedAddress
    }

}
