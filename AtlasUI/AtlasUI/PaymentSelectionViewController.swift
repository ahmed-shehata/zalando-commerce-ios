//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias PaymentCompletion = AtlasResult<PaymentRedirectURL> -> Void

enum PaymentRedirectURL: String {

    case redirect = ""
    case success = "?payment_status=success"
    case cancel = "?payment_status=cancel"
    case error = "?payment_status=error"

    init?(callbackURLString: String, urlString: String) {
        guard urlString.hasPrefix(callbackURLString) else { return nil }
        let rawValue = urlString.stringByReplacingOccurrencesOfString(callbackURLString, withString: "")
        guard let paymentRedirectURL = PaymentRedirectURL(rawValue: rawValue) else { return nil }
        self = paymentRedirectURL
    }

}

final class PaymentViewController: UIViewController, UIWebViewDelegate {

    var paymentCompletion: PaymentCompletion?
    private let paymentURL: NSURL
    private let callbackURL: NSURL

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(paymentURL: NSURL, callbackURL: NSURL) {
        self.callbackURL = callbackURL
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
        let callbackURLString = callbackURL.validAbsoluteString.lowercaseString
        guard let
            urlString = request.URL?.validAbsoluteString.lowercaseString,
            redirectUrl = PaymentRedirectURL(callbackURLString: callbackURLString, urlString: urlString) else { return true }

        paymentCompletion?(.success(redirectUrl))
        navigationController?.popViewControllerAnimated(true)
        return false
    }

    #if swift(>=2.3)
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        guard !errorBecuaseRequestCancelled(error) else { return }
        UserMessage.displayError(error)
    }
    #else
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        guard let error = error where !errorBecuaseRequestCancelled(error) else { return }
        UserMessage.displayError(error)
    }
    #endif

    private func errorBecuaseRequestCancelled(error: NSError) -> Bool {
        return error.domain == "WebKitErrorDomain"
    }

}
