//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class FullScreenErrorViewController: UIViewController {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .blackColor()
        label.textAlignment = .Center
        label.font = .systemFontOfSize(14, weight: UIFontWeightRegular)
        label.backgroundColor = UIColor(hex: 0xE5E5E5)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }

    func cancelButtonPressed() {
        AtlasUIViewController.instance?.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension FullScreenErrorViewController: UIBuilder {

    func configureView() {
        view.addSubview(messageLabel)
        let cancelButton = UIBarButtonItem(title: Localizer.string("button.general.cancel"),
                                           style: .Plain,
                                           target: self,
                                           action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = cancelButton
    }

    func configureConstraints() {
        messageLabel.fillInSuperView()
    }

}

extension FullScreenErrorViewController: UIDataBuilder {

    typealias T = UserPresentable

    func configureData(viewModel: T) {
        title = viewModel.displayedTitle
        messageLabel.text = viewModel.displayedMessage.uppercaseString
    }

}
