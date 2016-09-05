//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class CheckoutSummaryProductStackView: UIStackView {

    internal let articleImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.isCircle = true
        imageView.borderWidth = 1
        imageView.borderColor = UIColor(hex: 0xE5E5E5)
        return imageView
    }()

    internal let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2
        return stackView
    }()

    internal let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(16, weight: UIFontWeightBold)
        label.textColor = .blackColor()
        return label
    }()

    internal let articleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        return label
    }()

    internal let unitSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .lightGrayColor()
        return label
    }()

}

extension CheckoutSummaryProductStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(articleImageView)
        addArrangedSubview(detailsStackView)

        detailsStackView.addArrangedSubview(brandNameLabel)
        detailsStackView.addArrangedSubview(articleNameLabel)
        detailsStackView.addArrangedSubview(unitSizeLabel)
    }

    func configureConstraints() {
        articleImageView.setSquareAspectRatio()
        articleImageView.setWidthAsSuperViewWidth(0.2)
    }

}

extension CheckoutSummaryProductStackView: UIDataBuilder {

    typealias T = CheckoutSummaryViewController

    func configureData(viewModel: T) {
        articleImageView.setImage(fromUrl: viewModel.checkoutViewModel.article.thumbnailUrl)
        brandNameLabel.text = viewModel.checkoutViewModel.article.brand.name
        articleNameLabel.text = viewModel.checkoutViewModel.article.name
        unitSizeLabel.text = viewModel.loc("Size: %@", viewModel.checkoutViewModel.selectedUnit.size)
    }

}
