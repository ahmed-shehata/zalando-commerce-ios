//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

protocol CheckoutSummaryEditProductDataSource: class {

    var checkoutContainer: CheckoutContainerView { get }
    var selectedArticle: SelectedArticle { get }

}

protocol CheckoutSummaryEditProductDelegate: class {

    func updated(selectedArticle: SelectedArticle)

}

class CheckoutSummaryEditProductStackView: UIStackView {

    let sizeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(hex: 0x848484), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        button.addTarget(self, action: #selector(sizeButtonTapped), for: .touchUpInside)
        return button
    }()

    let sizeQuantitySeparatorView: BorderView = {
        let view = BorderView()
        view.rightBorder = true
        view.borderColor = UIColor(hex: 0xE5E5E5)
        return view
    }()

    let quantityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(hex: 0x848484), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        button.addTarget(self, action: #selector(quantityButtonTapped), for: .touchUpInside)
        return button
    }()

    weak var dataSource: CheckoutSummaryEditProductDataSource?
    weak var delegate: CheckoutSummaryEditProductDelegate?

    dynamic private func sizeButtonTapped() {
        guard let selectedArticle = dataSource?.selectedArticle else { return }
        dataSource?.checkoutContainer.displaySizes(selectedArticle: selectedArticle, animated: true) { [weak self] idx in
            guard self?.dataSource?.checkoutContainer.collectionView.type == .size else { return }
            let updatedArticle = SelectedArticle(article: selectedArticle.article, unitIndex: idx, quantity: selectedArticle.quantity)
            self?.delegate?.updated(selectedArticle: updatedArticle)
        }
    }

    dynamic private func quantityButtonTapped() {
        guard let selectedArticle = dataSource?.selectedArticle else { return }
        dataSource?.checkoutContainer.displayQuantites(selectedArticle: selectedArticle, animated: true) { [weak self] idx in
            guard self?.dataSource?.checkoutContainer.collectionView.type == .quantity else { return }
            let updatedArticle = SelectedArticle(article: selectedArticle.article, unitIndex: selectedArticle.unitIndex, quantity: idx + 1)
            self?.delegate?.updated(selectedArticle: updatedArticle)
        }
    }

}

extension CheckoutSummaryEditProductStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(sizeButton)
        addArrangedSubview(sizeQuantitySeparatorView)
        addArrangedSubview(quantityButton)
    }

    func configureConstraints() {
        sizeButton.setWidth(equalToView: quantityButton)
        sizeQuantitySeparatorView.setWidth(equalToConstant: UIView.onePixel)
    }

}

extension CheckoutSummaryEditProductStackView: UIDataBuilder {

    typealias T = SelectedArticle

    func configure(viewModel: T) {
        let sizeLabel = Localizer.format(string: "summaryView.button.size")
        let quantityLabel = Localizer.format(string: "summaryView.button.quantity")
        sizeButton.setTitle("\(sizeLabel): \(viewModel.unit.size)", for: .normal)
        quantityButton.setTitle("\(quantityLabel): \(viewModel.quantity)", for: .normal)
    }

}
