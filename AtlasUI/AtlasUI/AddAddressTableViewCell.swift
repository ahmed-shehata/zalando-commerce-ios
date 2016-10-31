//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {

    internal let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let addAddressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x555555)
        label.text = Localizer.string("Address.add.cellTitle")
        return label
    }()

    internal let addAddressButton: UIButton = {
        let button = UIButton(type: .ContactAdd)
        button.userInteractionEnabled = false
        return button
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AddAddressTableViewCell: UIBuilder {

    func configureView() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(addAddressLabel)
        stackView.addArrangedSubview(addAddressButton)
    }

    func configureConstraints() {
        stackView.fillInSuperView()
        addAddressButton.setSquareAspectRatio()
        addAddressButton.setWidth(equalToConstant: 20)
    }

}
