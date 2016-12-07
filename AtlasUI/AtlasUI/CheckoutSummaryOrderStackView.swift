//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class CheckoutSummaryOrderStackView: UIStackView {

    let orderHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = Localizer.format(string: "summaryView.label.orderHeader")
        return label
    }()

    let orderNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    let orderNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        label.text = Localizer.format(string: "summaryView.label.orderNumber")
        return label
    }()

    let orderNumberValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.textColor = UIColor(hex: 0x7F7F7F)
        label.textAlignment = .left
        return label
    }()

    let saveImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let saveImageButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitle("Save order details image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor(hex: 0xEEEEEE)
        return button
    }()

    fileprivate dynamic func saveImageButtonPressed() {
        saveImageContainer.isHidden = true

        guard
            let scrollView = superview?.superview as? UIScrollView,
            let image = scrollView.takeScreenshot() else {
                saveImageContainer.isHidden = false
                UserMessage.displayError(error: AtlasCheckoutError.unclassified)
                return
        }

        saveImageContainer.isHidden = false
        saveImageButton.isUserInteractionEnabled = false
        saveImageButton.setTitle("Image Saved to your photo library", for: .normal)

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        Async.delay(delay: 3) { [weak self] in
            self?.saveImageButton.isUserInteractionEnabled = true
            self?.saveImageButton.setTitle("Save order details image", for: .normal)
        }
    }

}

extension CheckoutSummaryOrderStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(orderHeaderLabel)
        addArrangedSubview(orderNumberStackView)
        addArrangedSubview(saveImageContainer)

        orderNumberStackView.addArrangedSubview(orderNumberTitleLabel)
        orderNumberStackView.addArrangedSubview(orderNumberValueLabel)

        saveImageContainer.addSubview(saveImageButton)
        saveImageButton.addTarget(self, action: #selector(saveImageButtonPressed), for: .touchUpInside)
    }

    func configureConstraints() {
        orderNumberTitleLabel.setWidth(equalToView: orderNumberValueLabel)
        saveImageButton.centerInSuperview()
        saveImageButton.snap(toSuperview: .top)
        saveImageButton.snap(toSuperview: .bottom)
    }

}

extension CheckoutSummaryOrderStackView: UIDataBuilder {

    typealias T = String?

    func configure(viewModel: String?) {
        orderNumberValueLabel.text = viewModel
    }

}
