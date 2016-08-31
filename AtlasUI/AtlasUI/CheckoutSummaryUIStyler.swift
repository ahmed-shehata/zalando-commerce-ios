//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class CheckoutSummaryUIStyler {

    private unowned let viewController: CheckoutSummaryViewController

    // First level Views
    internal let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        return stackView
    }()
    internal let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    internal let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    // Footer Views
    internal let footerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.font = .systemFontOfSize(12, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0xB2B2B2)
        return label
    }()
    internal let submitButton: RoundedButton = {
        let button = RoundedButton(type: .Custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(netHex: 0x519415)
        return button
    }()

    // Main StackView
    internal let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    // Product Summary
    internal let productSummaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()
    internal let articleImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.isCircle = true
        imageView.borderWidth = 1
        imageView.borderColor = UIColor(netHex: 0xE5E5E5)
        return imageView
    }()
    internal let productDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.spacing = 2
        return stackView
    }()
    internal let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
        label.textColor = .blackColor()
        return label
    }()
    internal let articleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .blackColor()
        return label
    }()
    internal let unitSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = .lightGrayColor()
        return label
    }()
    internal let productSummarySeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

    // Shipping Address
    internal let shippingAddressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()
    internal let shippingAddressLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .FillEqually
        stackView.spacing = 10
        return stackView
    }()
    internal let shippingAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()
    internal let shippingAddressValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(14, weight: UIFontWeightLight)
        label.textColor = UIColor(netHex: 0x7F7F7F)
        return label
    }()
    internal let shippingAddressArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tableArrow", bundledWith: CheckoutSummaryUIStyler.self))
        imageView.contentMode = .Center
        return imageView
    }()
    internal let shippingAddressSeparatorView: BorderView = {
        let view = BorderView()
        view.bottomBorder = true
        view.borderColor = UIColor(netHex: 0xE5E5E5)
        return view
    }()

    init (viewController: CheckoutSummaryViewController) {
        self.viewController = viewController
        setupView()
    }

    private func setupView() {
        viewController.view.backgroundColor = .whiteColor()
    }
}




//    @IBOutlet private weak var brandNameLabel: UILabel!
//    @IBOutlet private weak var articleNameLabel: UILabel!
//    @IBOutlet private weak var unitSizeLabel: UILabel!
//    @IBOutlet private weak var shippingAddressTitleLabel: UILabel!
//    @IBOutlet private weak var shippingAddressValueLabel: UILabel!
//    @IBOutlet private weak var billingAddressTitleLabel: UILabel!
//    @IBOutlet private weak var billingAddressValueLabel: UILabel!
//    @IBOutlet private weak var paymentTitleLabel: UILabel!
//    @IBOutlet private weak var paymentValueLabel: UILabel!
//    @IBOutlet private weak var shippingTitleLabel: UILabel!
//    @IBOutlet private weak var shippingPriceLabel: UILabel!
//    @IBOutlet private weak var totalTitleLabel: UILabel!
//    @IBOutlet private weak var totalPriceLabel: UILabel!
//
//    @IBOutlet private weak var footerLabel: UILabel!
//    @IBOutlet private weak var submitButton: UIButton!
//    @IBOutlet private weak var loaderView: UIView!
//
//    @IBOutlet private var arrowImageViews: [UIImageView] = []
//    @IBOutlet private weak var priceStackView: UIStackView!
//    @IBOutlet private weak var stackView: UIStackView! {
//        didSet {
//            stackView.subviews.flatMap { $0 as? UIStackView }.forEach {
//                $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//                $0.layoutMarginsRelativeArrangement = true
//            }
//        }
//    }
