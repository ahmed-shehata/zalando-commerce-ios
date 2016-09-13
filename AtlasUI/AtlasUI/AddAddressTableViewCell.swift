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
        return label
    }()

    internal let addAddressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addButton", bundledWith: AddAddressTableViewCell.self)
        imageView.contentMode = .ScaleAspectFit
        return imageView
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
        stackView.addArrangedSubview(addAddressImageView)
    }

    func configureConstraints() {
        stackView.fillInSuperView()
        addAddressImageView.setWidth(equalToConstant: 20)
        addAddressImageView.setSquareAspectRatio()
    }

}


extension AddAddressTableViewCell: UIDataBuilder {

    typealias T = LocalizerProviderType

    func configureData(viewModel: T) {
        addAddressLabel.text = viewModel.loc("Address.Add.cellTitle")
    }
}
