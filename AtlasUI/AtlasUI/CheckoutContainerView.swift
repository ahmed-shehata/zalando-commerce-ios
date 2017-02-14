//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

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
        button.alpha = 0
        return button
    }()

    let collectionViewContainerHeight: CGFloat = 50
    lazy var collectionViewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.transform = CGAffineTransform(translationX: 0, y: -self.collectionViewContainerHeight)
        return view
    }()

    let collectionView: CheckoutSummaryArticleSelectCollectionView = {
        let collectionView = CheckoutSummaryArticleSelectCollectionView()
        collectionView.backgroundColor = .white
        return collectionView
    }()

    func displaySizes(selectedArticle: SelectedArticle, animated: Bool, completion: @escaping CheckoutSummaryArticleRefineCompletion) {
        guard !selectedArticle.article.hasSingleUnit else { return }
        configureCollectionView(selectedArticle: selectedArticle, for: .size, animated: animated, completion: completion)
    }

    func displayQuantites(selectedArticle: SelectedArticle, animated: Bool, completion: @escaping CheckoutSummaryArticleRefineCompletion) {
        configureCollectionView(selectedArticle: selectedArticle, for: .quantity, animated: animated, completion: completion)
    }

    private func configureCollectionView(selectedArticle: SelectedArticle,
                                         for type: CheckoutSummaryArticleRefineType,
                                         animated: Bool,
                                         completion: @escaping CheckoutSummaryArticleRefineCompletion) {

        collectionView.completion = { [weak self] result in
            completion(result)
            guard !selectedArticle.notSelected else { return }
            self?.hideOverlay(animated: true)
        }

        if overlayButton.isHidden {
            showOverlay(animated: animated)
            collectionView.configure(with: selectedArticle, for: type, animated: false)
        } else if collectionView.type != type {
            collectionView.configure(with: selectedArticle, for: type, animated: true)
        } else {
            hideOverlay(animated: animated)
        }
    }

    dynamic fileprivate func overlayButtonTapped() {
        hideOverlay(animated: true)
    }

    private func showOverlay(animated: Bool) {
        guard animated else {
            overlayButton.isHidden = false
            overlayButton.alpha = 1
            collectionViewContainerView.transform = .identity
            return
        }

        overlayButton.isHidden = false
        overlayButton.alpha = 0
        UIView.animate(duration: .fast) { [weak self] in
            self?.overlayButton.alpha = 1
            self?.collectionViewContainerView.transform = .identity
        }
    }

    func hideOverlay(animated: Bool) {
        guard animated else {
            overlayButton.isHidden = true
            overlayButton.alpha = 0
            collectionViewContainerView.transform = CGAffineTransform(translationX: 0, y: -collectionViewContainerHeight)
            return
        }

        UIView.animate(duration: .fast, animations: { [weak self] in
            guard let strongSelf = self else { return }
            self?.overlayButton.alpha = 0
            self?.collectionViewContainerView.transform = CGAffineTransform(translationX: 0, y: -strongSelf.collectionViewContainerHeight)
        }, completion: { [weak self] _ in
            self?.overlayButton.isHidden = true
        })
    }

}

extension CheckoutContainerView: UIBuilder {

    func configureView() {
        addSubview(containerStackView)
        addSubview(overlayButton)
        addSubview(collectionViewContainerView)

        containerStackView.addArrangedSubview(scrollView)
        containerStackView.addArrangedSubview(footerStackView)

        scrollView.addSubview(mainStackView)
        collectionViewContainerView.addSubview(collectionView)
    }

    func configureConstraints() {
        containerStackView.fillInSuperview()
        overlayButton.fillInSuperview()

        collectionViewContainerView.snap(toSuperview: .top)
        collectionViewContainerView.snap(toSuperview: .right)
        collectionViewContainerView.snap(toSuperview: .left)
        collectionViewContainerView.setHeight(equalToConstant: collectionViewContainerHeight)

        collectionView.fillInSuperview()
    }

}

extension CheckoutContainerView: UIDataBuilder {

    typealias T = CheckoutSummaryViewModel

    func configure(viewModel: T) {
        mainStackView.configure(viewModel: viewModel)
        footerStackView.configure(viewModel: viewModel)

        overlayButton.removeTarget(self, action: nil, for: .touchUpInside)
        if viewModel.layout.allowArticleRefine {
            overlayButton.addTarget(self, action: #selector(overlayButtonTapped), for: .touchUpInside)
        }
    }

}
