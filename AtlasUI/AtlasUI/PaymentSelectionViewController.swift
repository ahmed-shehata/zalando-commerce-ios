//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

enum Result<T> {

    case success(T)
    case failure()

}

typealias PaymentCompletion = Result<String> -> Void

final class PaymentSelectionViewController: UIViewController, UIWebViewDelegate {

    private let paymentSelectionURL: NSURL

    private let paymentCompletion: PaymentCompletion?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(paymentSelectionURL: NSURL, completion: PaymentCompletion? = nil) {
        self.paymentSelectionURL = paymentSelectionURL
        self.paymentCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        webView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        webView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        webView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true

        webView.loadRequest(NSURLRequest(URL: paymentSelectionURL))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            return true
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        dismissViewController(.failure(), animated: true)
    }

    private func dismissViewController(result: Result<String>, animated: Bool = true) {
        navigationController?.popViewControllerAnimated(animated)
        self.paymentCompletion?(result)
    }

}
