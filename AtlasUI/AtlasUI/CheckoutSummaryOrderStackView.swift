//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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
        label.text = "\n" + Localizer.format(string: "summaryView.label.orderHeader")
        return label
    }()

    let headerSeparator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        label.text = " "
        return label
    }()

    let orderNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    let orderNumberSeparator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.text = " "
        return label
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

    let bottomSeparator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: UIFontWeightLight)
        label.text = " "
        return label
    }()

    let saveImageButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitle(Localizer.format(string: "summaryView.button.saveOrderImage"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor(hex: 0xEEEEEE)
        button.accessibilityIdentifier = "save-order-image-button"
        return button
    }()

    let imageSavedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(hex: 0x509614)
        label.textAlignment = .center
        label.text = Localizer.format(string: "summaryView.label.orderImageSaved")
        label.alpha = 0
        label.accessibilityIdentifier = "image-saved-success-label"
        return label
    }()

}

extension CheckoutSummaryOrderStackView {

    fileprivate dynamic func saveImageButtonPressed() {
        AtlasUIViewController.shared?.prepareSubviewsForScreenShot()
        UIView.waitForUIState {
            let screenShot = AtlasUIViewController.shared?.mainNavigationController.view.takeScreenshot()
            AtlasUIViewController.shared?.cleanupSubviewsAfterScreenShot()

            guard let image = screenShot else {
                UserMessage.displayError(error: AtlasCheckoutError.unclassified)
                return
            }

            AtlasUIViewController.shared?.showLoader()
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        AtlasUIViewController.shared?.hideLoader()
        guard error == nil else { return UserMessage.displayError(error: AtlasCheckoutError.photosLibraryAccessNotAllowed) }
        showSavedLabel()
    }

    private func showSavedLabel() {
        UIView.animate(duration: .normal) { [weak self] in
            self?.saveImageButton.alpha = 0
            self?.imageSavedLabel.alpha = 1
        }

        Async.delay(delay: 4) {
            UIView.animate(duration: .normal) { [weak self] in
                self?.saveImageButton.alpha = 1
                self?.imageSavedLabel.alpha = 0
            }
        }
    }

}

extension CheckoutSummaryOrderStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(orderHeaderLabel)
        addArrangedSubview(headerSeparator)
        addArrangedSubview(orderNumberStackView)
        addArrangedSubview(orderNumberSeparator)

        orderNumberStackView.addArrangedSubview(orderNumberTitleLabel)
        orderNumberStackView.addArrangedSubview(orderNumberValueLabel)

        if accessPhotosIsStatedInInfoPlist {
            addArrangedSubview(saveImageContainer)
            addArrangedSubview(bottomSeparator)
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

extension CheckoutSummaryOrderStackView: UIScreenShotBuilder {

    func prepareForScreenShot() {
        saveImageContainer.isHidden = true
        bottomSeparator.isHidden = true
    }

    func cleanupAfterScreenShot() {
        saveImageContainer.isHidden = false
        bottomSeparator.isHidden = false
    }

}
