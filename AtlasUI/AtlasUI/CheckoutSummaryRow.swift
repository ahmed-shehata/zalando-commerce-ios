//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

internal final class CheckoutSummaryRow: UIView, UIGestureRecognizerDelegate {

    let detailTextLabel = UILabel()
    let titleTextLabel = UILabel()
    let arrowImageView = UIImageView()
    var tapAction: (() -> Void)? {
        didSet {
            if tapAction != nil {
                arrowImageView.image = UIImage(named: "arrow", bundledWith: CheckoutSummaryRow.self)
                arrowImageView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(arrowImageView)
                arrowImageView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -10).active = true
                arrowImageView.heightAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 0.04).active = true
                arrowImageView.widthAnchor.constraintEqualToAnchor(arrowImageView.heightAnchor, multiplier: 0.60).active = true
                arrowImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CheckoutSummaryRow.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        setup()
    }

    func setup() {
        self.removeAllSubviews()
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleTextLabel)
        titleTextLabel.text = titleTextLabel.text?.uppercaseString
        titleTextLabel.font = titleTextLabel.font.fontWithSize(13)
        titleTextLabel.textColor = UIColor.grayColor()
        titleTextLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 10).active = true
        titleTextLabel.heightAnchor.constraintEqualToConstant(10).active = true
        titleTextLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true

        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(detailTextLabel)
        detailTextLabel.text = detailTextLabel.text?.stringByReplacingOccurrencesOfString(", ", withString: "\n").uppercaseString
        detailTextLabel.font = detailTextLabel.font.fontWithSize(13)
        detailTextLabel.numberOfLines = 3
        detailTextLabel.leadingAnchor.constraintEqualToAnchor(self.titleTextLabel.leadingAnchor, constant: 100).active = true
        detailTextLabel.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        detailTextLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true

        let bottomSeparatorView = UIView()
        bottomSeparatorView.layer.borderWidth = 5
        bottomSeparatorView.layer.borderColor = UIColor.blackColor().CGColor
        bottomSeparatorView.alpha = 0.2
        self.addSubview(bottomSeparatorView)
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false

        bottomSeparatorView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 0.95).active = true
        bottomSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        bottomSeparatorView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        bottomSeparatorView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
    }

    func handleTap(sender: UITapGestureRecognizer? = nil) {
        tapAction?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
