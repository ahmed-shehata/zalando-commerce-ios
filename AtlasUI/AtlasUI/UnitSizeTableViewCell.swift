//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class UnitSizeTableViewCell: UITableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let sizeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = .black
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
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
        backgroundColor = .clear
        isOpaque = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(sizeLabel)
        stackView.addArrangedSubview(priceLabel)
    }

    func configureConstraints() {
        stackView.fillInSuperview()
    }

}

extension UnitSizeTableViewCell: UIDataBuilder {

    typealias T = Article.Unit

    func configure(viewModel: T) {
        sizeLabel.text = viewModel.size
        priceLabel.text = Localizer.format(price: viewModel.price)
        accessibilityLabel = "size-cell-\(viewModel.size)"
    }

}
