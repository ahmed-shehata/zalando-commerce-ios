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

    let imageSavedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(hex: 0x509614)
        label.textAlignment = .center
        label.text = "✓ Image saved to your photo library"
        label.alpha = 0
        return label
    }()

}

extension CheckoutSummaryOrderStackView {

    fileprivate dynamic func saveImageButtonPressed() {
        guard let scrollView = superview?.superview as? UIScrollView else {
            UserMessage.displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        let (contentOffset, frame) = prepareViewForTakingImage(scrollView: scrollView)
        guard let image = scrollView.takeScreenshot() else {
            cleanupViewAfterTakingImage(scrollView: scrollView, originalContentOffset: contentOffset, originalFrame: frame)
            UserMessage.displayError(error: AtlasCheckoutError.unclassified)
            return
        }

        cleanupViewAfterTakingImage(scrollView: scrollView, originalContentOffset: contentOffset, originalFrame: frame)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .allowUserInteraction, animations: { [weak self] in

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                self?.saveImageButton.alpha = 0
                self?.imageSavedLabel.alpha = 1
            }

            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1) {
                self?.saveImageButton.alpha = 1
                self?.imageSavedLabel.alpha = 0
            }

        }, completion: nil)
    }

    private func prepareViewForTakingImage(scrollView: UIScrollView) -> (originalContentOffset: CGPoint, originalFrame: CGRect) {
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame

        let imageHeight = scrollView.contentSize.height - saveImageContainer.frame.height - spacing
        let imageSize = CGSize(width: scrollView.contentSize.width, height: imageHeight)
        saveImageContainer.isHidden = true

        scrollView.contentOffset = .zero
        scrollView.frame = CGRect(origin: CGPoint.zero, size: imageSize)

        return (savedContentOffset, savedFrame)
    }

    private func cleanupViewAfterTakingImage(scrollView: UIScrollView, originalContentOffset: CGPoint, originalFrame: CGRect) {
        saveImageContainer.isHidden = false
        scrollView.alpha = 0

        Async.delay(delay: 0.1) {
            scrollView.alpha = 1
            scrollView.contentOffset = originalContentOffset
            scrollView.frame = originalFrame
        }
    }

}

extension CheckoutSummaryOrderStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(orderHeaderLabel)
        addArrangedSubview(orderNumberStackView)

        orderNumberStackView.addArrangedSubview(orderNumberTitleLabel)
        orderNumberStackView.addArrangedSubview(orderNumberValueLabel)

        if accessPhotosIsStatedInInfoPlist {
            addArrangedSubview(saveImageContainer)
            saveImageContainer.addSubview(imageSavedLabel)
            saveImageContainer.addSubview(saveImageButton)
            saveImageButton.addTarget(self, action: #selector(saveImageButtonPressed), for: .touchUpInside)
        }
    }

    func configureConstraints() {
        orderNumberTitleLabel.setWidth(equalToView: orderNumberValueLabel)
        imageSavedLabel.fillInSuperview()
        saveImageButton.centerInSuperview()
        saveImageButton.snap(toSuperview: .top)
        saveImageButton.snap(toSuperview: .bottom)
    }

    private var accessPhotosIsStatedInInfoPlist: Bool {
        return Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"] != nil
    }

}

extension CheckoutSummaryOrderStackView: UIDataBuilder {

    typealias T = String?

    func configure(viewModel: String?) {
        orderNumberValueLabel.text = viewModel
    }

}
