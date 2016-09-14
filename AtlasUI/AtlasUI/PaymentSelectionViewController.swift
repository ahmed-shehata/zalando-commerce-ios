//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias PaymentCompletion = AtlasResult<Bool> -> Void

final class PaymentSelectionViewController: UIViewController, UIWebViewDelegate {

    var paymentCompletion: PaymentCompletion?
    private let paymentSelectionURL: NSURL
    private let successURL = "http://de.zalando.atlas.atlascheckoutdemo/redirect"

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
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
        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.fillInSuperView()
        webView.loadRequest(NSURLRequest(URL: paymentSelectionURL))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let success = request.URL?.absoluteString.hasPrefix(successURL) where success else { return true }
        dismissViewController(.success(true))
        return false
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        guard let error = error where !errorBecuaseRequestCancelled(error) else { return }
        dismissViewController(.failure(error), animated: true)
    }

    private func errorBecuaseRequestCancelled(error: NSError) -> Bool {
        return error.domain == "WebKitErrorDomain"
    }

    private func dismissViewController(result: AtlasResult<Bool>, animated: Bool = true) {
        navigationController?.popViewControllerAnimated(animated)
        paymentCompletion?(result)
    }

}
