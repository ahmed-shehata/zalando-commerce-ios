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

    let collectionViewHeight: CGFloat = 50
    let collectionView: CheckoutSummaryArticleSelectCollectionView = {
        let collectionView = CheckoutSummaryArticleSelectCollectionView()
        collectionView.backgroundColor = .white
        return collectionView
    }()

    func displaySizes(selectedArticle: SelectedArticle, animated: Bool, completion: CheckoutContainerViewEditCompletion) {
        if overlayButton.isHidden {
            showOverlay(animated: animated)
            collectionView.configure(with: selectedArticle, for: .size)
        } else if collectionView.type == .quantity {
            collectionView.configure(with: selectedArticle, for: .size)
        } else {
            hideOverlay(animated: animated)
        }
    }

    func displayQuantites(selectedArticle: SelectedArticle, animated: Bool, completion: CheckoutContainerViewEditCompletion) {
        if overlayButton.isHidden {
            showOverlay(animated: animated)
            collectionView.configure(with: selectedArticle, for: .quantity)
        } else if collectionView.type == .size {
            collectionView.configure(with: selectedArticle, for: .quantity)
        } else {
            hideOverlay(animated: animated)
        }
    }

    dynamic private func overlayButtonTapped() {
        hideOverlay(animated: true)
    }

    private func showOverlay(animated: Bool) {
        guard animated else {
            overlayButton.isHidden = false
            overlayButton.alpha = 1
            collectionView.transform = .identity
            return
        }

        overlayButton.isHidden = false
        overlayButton.alpha = 0
        UIView.animate(duration: .fast) { [weak self] in
            self?.overlayButton.alpha = 1
            self?.collectionView.transform = .identity
        }
    }

    private func hideOverlay(animated: Bool) {
        guard animated else {
            overlayButton.isHidden = true
            overlayButton.alpha = 0
            collectionView.transform = CGAffineTransform(translationX: 0, y: -collectionViewHeight)
            return
        }

        UIView.animate(duration: .fast, animations: { [weak self] in
            guard let strongSelf = self else { return }
            self?.overlayButton.alpha = 0
            self?.collectionView.transform = CGAffineTransform(translationX: 0, y: -strongSelf.collectionViewHeight)
        }, completion: { [weak self] _ in
            self?.overlayButton.isHidden = true
        })
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
        collectionView.setHeight(equalToConstant: collectionViewHeight)
    }

}

extension CheckoutContainerView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        mainStackView.configure(viewModel: viewModel)
        footerStackView.configure(viewModel: viewModel)
    }

}
