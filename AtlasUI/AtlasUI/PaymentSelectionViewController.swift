//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias PaymentCompletion = (PaymentStatus) -> Void

final class PaymentViewController: UIViewController, UIWebViewDelegate {

    var paymentCompletion: PaymentCompletion?
    private let paymentURL: URL
    private let callbackURLComponents: URLComponents?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .white
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(paymentURL: URL, callbackURL: URL) {
        self.callbackURLComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true)
        self.paymentURL = paymentURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)

        webView.fillInSuperview()
        webView.loadRequest(URLRequest(url: paymentURL))
    }

    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url,
            let callbackURLComponents = callbackURLComponents,
            let requestURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else { return true }

        guard let paymentStatus = PaymentStatus(callbackURLComponents: callbackURLComponents,
                                                requestURLComponents: requestURLComponents) else { return true }

        paymentCompletion?(paymentStatus)
        _ = navigationController?.popViewController(animated: true)
        return false
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if !error.isRequestCancelledError {
            UserError.display(error: error)
        }
    }

}

private extension Error {

    var isRequestCancelledError: Bool {
        // returning false from `shouldStartLoadWith` method results in error sent by the webview in `didFailLoadWithError` method
        // We could catch this error by cheking the error domain for `WebKitErrorDomain` and prevent this error from displying to the user
        return (self as NSError).domain == "WebKitErrorDomain"
    }

}
