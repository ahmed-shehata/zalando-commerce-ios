//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

struct AddressCheckDataModel {

    let header: String
    let addresses: [Address]

    struct Address {
        let title: String
        let address: CheckAddress
    }

}

class AddressCheckStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .center
        return label
    }()

    var addressesRow: [(label: UILabel, view: AddressCheckRowView)] = []
    var selectedAddress: CheckAddress? {
        didSet {
            addressesRow.forEach { $0.view.selectRow(selected: $0.view.selectButton.address === selectedAddress) }
        }
    }

    fileprivate func createAddressRowTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "\n" + title
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }

    fileprivate func createAddressRowView(address: CheckAddress) -> AddressCheckRowView {
        let view = AddressCheckRowView()
        view.selectButton.addTarget(self, action: #selector(addressRowSelected(button:)), for: .touchUpInside)
        return view
    }

    dynamic private func addressRowSelected(button: AddressCheckRowButton) {
        selectedAddress = button.address
    }

}

extension AddressCheckStackView: UIBuilder {

    func configureView() {
        removeAllSubviews()
        addArrangedSubview(titleLabel)
        addressesRow.forEach {
            addArrangedSubview($0.label)
            addArrangedSubview($0.view)
        }
    }

}

extension AddressCheckStackView: UIDataBuilder {

    typealias T = AddressCheckDataModel

    func configure(viewModel: AddressCheckDataModel) {
        titleLabel.text = viewModel.header
        viewModel.addresses.forEach { addressModel in
            let label = createAddressRowTitleLabel(title: addressModel.title)
            let view = createAddressRowView(address: addressModel.address)
            addressesRow.append((label: label, view: view))
            view.configure(viewModel: addressModel.address)
        }
        buildView()
        selectedAddress = viewModel.addresses.last?.address
    }

}
