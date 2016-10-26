//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class AddressRowViewCell: UITableViewCell {

    internal let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()

    internal let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x555555)
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AddressRowViewCell: UIBuilder {

    func configureView() {
        editingAccessoryType = .DisclosureIndicator
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addressLabel)
    }

    func configureConstraints() {
        stackView.fillInSuperView()
    }

}

extension AddressRowViewCell: UIDataBuilder {

    typealias T = EquatableAddress

    func configureData(viewModel: T) {
        titleLabel.text = viewModel.formattedContact?.trimmed
        addressLabel.text = viewModel.formattedPostalAddress.trimmed
    }

}
