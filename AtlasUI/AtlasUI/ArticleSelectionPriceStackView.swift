//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

struct ArticleSelectionPriceViewModel {

    let itemPrice: Money
    let totalPrice: Money

}

class ArticleSelectionPriceStackView: UIStackView {

    let itemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let itemValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

    fileprivate let dummySeparatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 4)
        label.text = " "
        return label
    }()

    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    let vatTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .right
        return label
    }()

}

extension ArticleSelectionPriceStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(itemStackView)
        addArrangedSubview(dummySeparatorLabel)
        addArrangedSubview(totalStackView)
        addArrangedSubview(vatTitleLabel)

        itemStackView.addArrangedSubview(itemTitleLabel)
        itemStackView.addArrangedSubview(itemValueLabel)

        totalStackView.addArrangedSubview(totalTitleLabel)
        totalStackView.addArrangedSubview(totalValueLabel)
    }

}

extension ArticleSelectionPriceStackView: UIDataBuilder {

    typealias T = ArticleSelectionPriceViewModel

    func configure(viewModel: ArticleSelectionPriceViewModel) {
        itemTitleLabel.text = Localizer.format(string: "selectionView.label.price.item")
        itemValueLabel.text = Localizer.format(price: viewModel.itemPrice)
        totalTitleLabel.text = Localizer.format(string: "summaryView.label.price.total")
        totalValueLabel.text = Localizer.format(price: viewModel.totalPrice)
        vatTitleLabel.text = Localizer.format(string: "summaryView.label.price.vat")
    }

}
