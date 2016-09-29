//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class UnitSizeTableViewCell: UITableViewCell {

    internal let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let sizeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        return label
    }()

    internal let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Right
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
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

extension UnitSizeTableViewCell: UIBuilder {

    func configureView() {
        backgroundColor = .clearColor()
        opaque = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(sizeLabel)
        stackView.addArrangedSubview(priceLabel)
    }

    func configureConstraints() {
        stackView.fillInSuperView()
    }

}

extension UnitSizeTableViewCell: UIDataBuilder {

    typealias T = Article.Unit

    func configureData(viewModel: T) {
        sizeLabel.text = viewModel.size
        priceLabel.text = UILocalizer.price(viewModel.price.amount)
        accessibilityLabel = "size-cell-\(viewModel.size)"
    }

}
