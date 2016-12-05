//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias PaymentCompletion = (PaymentStatus) -> Void

final class PaymentViewController: UIViewController, UIWebViewDelegate {

    var paymentCompletion: PaymentCompletion?
    private let paymentURL: NSURL
    private let callbackURLComponents: NSURLComponents?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(paymentURL: NSURL, callbackURL: NSURL) {
        self.callbackURLComponents = NSURLComponents(URL: callbackURL, resolvingAgainstBaseURL: true)
        self.paymentURL = paymentURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.fillInSuperView()
        webView.loadRequest(NSURLRequest(URL: paymentURL))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard
            let url = request.URL,
            let callbackURLComponents = callbackURLComponents,
            let requestURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
            else { return true }

        guard let paymentStatus = PaymentStatus(callbackURLComponents: callbackURLComponents,
                                                requestURLComponents: requestURLComponents) else { return true }

        paymentCompletion?(paymentStatus)
        navigationController?.popViewControllerAnimated(true)
        return false
    }

    #if swift(>=2.3)
        func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
            handle(webView: webView, error: error)
        }
    #else
        func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
            guard let error = error else { return }
            handle(webView: webView, error: error)
        }
    #endif

    private func handle(webView: UIWebView, error: NSError) {
        if !error.isWebKitError {
            UserMessage.displayError(error)
        }
    }

}

private extension NSError {

    var isWebKitError: Bool {
        return self.domain == "WebKitErrorDomain"
    }

}
