//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias PaymentCompletion = (PaymentStatus) -> Void

enum PaymentStatus: String {

    case redirect = ""
    case success = "success"
    case cancel = "cancel"
    case error = "error"

    static let statusKey = "payment_status"

    init?(callbackURLComponents: URLComponents, requestURLComponents: URLComponents) {
        guard let
            callbackHost = callbackURLComponents.host,
            let requestHost = requestURLComponents.host,
            callbackHost.lowercased() == requestHost.lowercased()
            else { return nil }

        guard let
            rawValue = requestURLComponents.queryItems?.filter({ $0.name == PaymentStatus.statusKey }).first?.value,
            let paymentStatus = PaymentStatus(rawValue: rawValue)
            else { self = .redirect; return }

        self = paymentStatus
    }

}

final class PaymentViewController: UIViewController {

    var paymentCompletion: PaymentCompletion?
    fileprivate let paymentURL: URL
    fileprivate let callbackURLComponents: URLComponents?

    fileprivate lazy var webView: UIWebView = {
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
        view.backgroundColor = .white
        view.addSubview(webView)

        webView.fillInSuperview()
        webView.loadRequest(URLRequest(url: paymentURL))
    }

}

extension PaymentViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url,
            let callbackURLComponents = callbackURLComponents,
            let requestURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else { return true }

        guard let paymentStatus = PaymentStatus(callbackURLComponents: callbackURLComponents,
                                                requestURLComponents: requestURLComponents) else { return true }

        paymentCompletion?(paymentStatus)
        let _ = navigationController?.popViewController(animated: true)
        return false
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if let error = error as NSError?, !error.isWebKitError {
            UserMessage.displayError(error)
        }
    }

}

private extension NSError {

    var isWebKitError: Bool {
        return self.domain == "WebKitErrorDomain"
    }

}
