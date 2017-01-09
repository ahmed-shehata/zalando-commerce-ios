//
//  Copyright © 2017 Zalando SE. All rights reserved.
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
        if let error = error as NSError?, !error.isWebKitError {
            UserMessage.displayError(error: error)
        }
    }

}

private extension NSError {

    var isWebKitError: Bool {
        return self.domain == "WebKitErrorDomain"
    }

}
