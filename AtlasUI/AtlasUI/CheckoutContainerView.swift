//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias CheckoutContainerViewEditCompletion = (SelectedArticle) -> Void

class CheckoutContainerView: UIView {

    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()

    let mainStackView: CheckoutSummaryMainStackView = {
        let stackView = CheckoutSummaryMainStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let footerStackView: CheckoutSummaryFooterStackView = {
        let stackView = CheckoutSummaryFooterStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let overlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor(white: 0, alpha: 0.5)
        button.isHidden = true
        button.addTarget(self, action: #selector(overlayButtonTapped), for: .touchUpInside)
        return button
    }()

    let collectionView: CheckoutSummaryArticleSelectCollectionView = {
        let collectionView = CheckoutSummaryArticleSelectCollectionView()
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        return collectionView
    }()

    func displaySizes(selectedArticle: SelectedArticle, completion: CheckoutContainerViewEditCompletion) {
        if overlayButton.isHidden {
            overlayButton.isHidden = false
            collectionView.isHidden = false
            collectionView.configure(with: selectedArticle, for: .size)
        } else if collectionView.type == .quantity {
            collectionView.configure(with: selectedArticle, for: .size)
        } else {
            overlayButton.isHidden = true
            collectionView.isHidden = true
        }
    }

    func displayQuantites(selectedArticle: SelectedArticle, completion: CheckoutContainerViewEditCompletion) {
        if overlayButton.isHidden {
            overlayButton.isHidden = false
            collectionView.isHidden = false
            collectionView.configure(with: selectedArticle, for: .quantity)
        } else if collectionView.type == .size {
            collectionView.configure(with: selectedArticle, for: .quantity)
        } else {
            overlayButton.isHidden = true
            collectionView.isHidden = true
        }
    }

    dynamic private func overlayButtonTapped() {
        overlayButton.isHidden = true
        collectionView.isHidden = true
    }

}

extension CheckoutContainerView: UIBuilder {

    func configureView() {
        addSubview(containerStackView)
        addSubview(overlayButton)
        addSubview(collectionView)

        containerStackView.addArrangedSubview(scrollView)
        containerStackView.addArrangedSubview(footerStackView)

        scrollView.addSubview(mainStackView)
    }

    func configureConstraints() {
        containerStackView.fillInSuperview()
        overlayButton.fillInSuperview()

        collectionView.snap(toSuperview: .top)
        collectionView.snap(toSuperview: .right)
        collectionView.snap(toSuperview: .left)
        collectionView.setHeight(equalToConstant: 50)
    }

}

extension CheckoutContainerView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        mainStackView.configure(viewModel: viewModel)
        footerStackView.configure(viewModel: viewModel)
    }

}
