//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let addAddressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x555555)
        label.text = Localizer.format(string: "addressListView.add.cellTitle")
        return label
    }()

    let addAddressButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.isUserInteractionEnabled = false
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
        stackView.fillInSuperview()
        addAddressButton.setSquareAspectRatio()
        addAddressButton.setWidth(equalToConstant: 20)
    }

}
