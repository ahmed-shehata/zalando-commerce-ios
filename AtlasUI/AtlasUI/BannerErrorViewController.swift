//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class BannerErrorViewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orangeColor()
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .whiteColor()
        label.textAlignment = .Left
        label.font = .systemFontOfSize(12, weight: UIFontWeightRegular)
        label.backgroundColor = .clearColor()
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .whiteColor()
        label.textAlignment = .Left
        label.font = .systemFontOfSize(12, weight: UIFontWeightLight)
        label.backgroundColor = .clearColor()
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.backgroundColor = .clearColor()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }

    func cancelButtonPressed() {
        UIView.animateWithDuration(0.3, animations: {  [weak self] in
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.view.removeFromSuperview()
            self?.removeFromParentViewController()
        }
    }

}

extension BannerErrorViewController: UIBuilder {

    func configureView() {
        view.alpha = 0
        view.userInteractionEnabled = true
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(cancelButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), forControlEvents: .TouchUpInside)
    }

    func configureConstraints() {
        containerView.snapAnchorToSuperView(.top)
        containerView.snapAnchorToSuperView(.right)
        containerView.snapAnchorToSuperView(.left)
        stackView.fillInSuperView()
        cancelButton.fillInSuperView()
    }

}

extension BannerErrorViewController: UIDataBuilder {

    typealias T = UserPresentable

    func configureData(viewModel: T) {
        titleLabel.text = viewModel.displayedTitle
        messageLabel.text = viewModel.displayedMessage.oneLineString

        UIView.animateWithDuration(0.3) {  [weak self] in
            self?.view.alpha = 1
        }
    }

}
