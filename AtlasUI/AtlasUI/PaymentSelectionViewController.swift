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

    var paymentCompletion: PaymentCompletion?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(paymentSelectionURL: NSURL) {
        self.paymentSelectionURL = paymentSelectionURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.fillInSuperView()
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
        paymentCompletion?(result)
    }

}
