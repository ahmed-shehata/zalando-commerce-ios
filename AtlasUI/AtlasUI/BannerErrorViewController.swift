//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class BannerErrorViewController: UIViewController {

    fileprivate static let topMargin: CGFloat = UIScreen.isSmallScreen ? 25 : 10

    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: topMargin, left: 30, bottom: 10, right: 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightBold)
        label.backgroundColor = .clear
        return label
    }()

    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.backgroundColor = .clear
        return label
    }()

    fileprivate let cancelIconLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .right
        label.text = "x"
        label.font = .systemFont(ofSize: 10, weight: UIFontWeightLight)
        label.backgroundColor = .clear
        return label
    }()

    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.alpha = 0
        buildView()
    }

    func showBanner() {
        containerView.transform = CGAffineTransform(translationX: 0, y: -containerView.bounds.height)
        view.alpha = 1

        UIView.animate { [weak self] in
            self?.containerView.transform = CGAffineTransform.identity
        }
    }

    func hideBanner() {
        let bannerHeight = containerView.bounds.height
        UIView.animate(animations: { [weak self] in
            self?.containerView.transform = CGAffineTransform(translationX: 0, y: -bannerHeight)
        }) { [weak self] _ in
            self?.view.removeFromSuperview()
            self?.removeFromParentViewController()
        }
    }

    func cancelButtonPressed() {
        hideBanner()
    }

}

extension BannerErrorViewController: UIBuilder {

    func configureView() {
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(cancelIconLabel)
        containerView.addSubview(cancelButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }

    func configureConstraints() {
        containerView.snapAnchorToSuperView(anchor: .top)
        containerView.snapAnchorToSuperView(anchor: .right)
        containerView.snapAnchorToSuperView(anchor: .left)
        stackView.fillInSuperview()

        cancelIconLabel.snapAnchorToSuperView(anchor: .top, constant: BannerErrorViewController.topMargin)
        cancelIconLabel.snapAnchorToSuperView(anchor: .right, constant: -10)
        cancelButton.fillInSuperview()
    }

}

extension BannerErrorViewController: UIDataBuilder {

    typealias T = UserPresentable

    func configure(viewModel: T) {
        titleLabel.text = viewModel.displayedTitle
        messageLabel.text = viewModel.displayedMessage.onelined()
        showBanner()
    }

}
