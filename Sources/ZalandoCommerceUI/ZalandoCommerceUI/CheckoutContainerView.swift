//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class CheckoutContainerView: UIView {

    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    let scrollView: KeyboardScrollView = {
        let scrollView = KeyboardScrollView()
        scrollView.backgroundColor = .white
        scrollView.keyboardDismissMode = .interactive
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
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
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

    var articleRefineArrowHandler: CheckoutSummaryArticleRefineArrowHandler?
    let collectionView: CheckoutSummaryArticleSelectCollectionView = {
        let collectionView = CheckoutSummaryArticleSelectCollectionView()
        collectionView.backgroundColor = .white
        return collectionView
    }()

    func displaySizes(selectedArticle: SelectedArticle,
                      animated: Bool,
                      arrowHandler: @escaping CheckoutSummaryArticleRefineArrowHandler,
                      completion: @escaping CheckoutSummaryArticleRefineCompletion) {

        guard !selectedArticle.article.hasSingleUnit else { return }
        articleRefineArrowHandler = arrowHandler
        configureArticleRefine(selectedArticle: selectedArticle, for: .size, animated: animated, completion: completion)
    }

    func displayQuantites(selectedArticle: SelectedArticle,
                          animated: Bool,
                          arrowHandler: @escaping CheckoutSummaryArticleRefineArrowHandler,
                          completion: @escaping CheckoutSummaryArticleRefineCompletion) {

        articleRefineArrowHandler = arrowHandler
        configureArticleRefine(selectedArticle: selectedArticle, for: .quantity, animated: animated, completion: completion)
    }

    private func configureArticleRefine(selectedArticle: SelectedArticle,
                                        for type: CheckoutSummaryArticleRefineType,
                                        animated: Bool,
                                        completion: @escaping CheckoutSummaryArticleRefineCompletion) {

        collectionView.completion = { [weak self] result in
            completion(result)
            guard selectedArticle.isSelected else { return }
            self?.hideOverlay(animated: true)
        }

        if overlayButton.isHidden {
            showOverlay(animated: animated)
            collectionView.configure(with: selectedArticle, for: type, animated: false)
            articleRefineArrowHandler?(type, animated)
        } else if collectionView.type != type {
            collectionView.configure(with: selectedArticle, for: type, animated: true)
            articleRefineArrowHandler?(type, animated)
        } else {
            hideOverlay(animated: animated)
        }
    }

    dynamic fileprivate func overlayButtonTapped() {
        hideOverlay(animated: true)
    }

    private func showOverlay(animated: Bool) {
        overlayButton.isHidden = false
        overlayButton.alpha = 0

        UIView.animate(duration: animated ? .fast : .noAnimation) { [weak self] in
            self?.overlayButton.alpha = 1
            self?.collectionViewContainerView.transform = .identity
        }
    }

    func hideOverlay(animated: Bool) {
        articleRefineArrowHandler?(nil, animated)

        UIView.animate(duration: animated ? .fast : .noAnimation, animations: { [weak self] in
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
        scrollView.registerForKeyboardNotifications()

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
        if viewModel.layout.allowsArticleRefine {
            overlayButton.addTarget(self, action: #selector(overlayButtonTapped), for: .touchUpInside)
        }
    }

}

extension CheckoutContainerView: UIScreenshotBuilder {

    var scrollViewDifference: CGFloat {
        return scrollView.contentSize.height - scrollView.frame.height - footerStackView.frame.height
    }

    func prepareForScreenshot() {
        containerStackView.removeArrangedSubview(footerStackView)
    }

    func cleanupAfterScreenshot() {
        containerStackView.addArrangedSubview(footerStackView)
    }

}
