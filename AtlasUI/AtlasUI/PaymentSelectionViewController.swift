//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

private enum Result<T> {

    case success(T)
    case failure(ErrorType)

}

private enum ErrorCode: Int {

    case Unknown = -1
    case MissingURL = 1
    case AccessDenied = 2
    case RequestFailed = 3
    case NoAccessToken = 4

}

typealias PaymentCompletion = Result<String> -> Void

final class PaymentSelectionViewController: UIViewController, UIWebViewDelegate {

    private let loginURL: NSURL

    private let paymentCompletion: PaymentCompletion?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(loginURL: NSURL, completion: PaymentCompletion? = nil) {
        self.loginURL = loginURL
        self.paymentCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
            target: self,
            action: .cancelButtonTapped)
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor).active = true
        webView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor).active = true
        webView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        webView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true

        webView.loadRequest(NSURLRequest(URL: loginURL))
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            print(request.URL)
            return true
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
        // self.dismissViewController(withFailureCode: .RequestFailed)
    }

//    private func dismissViewController(withFailureCode code: ErrorCode, animated: Bool = true) -> Bool {
//        // return dismissViewController(.failure(ErrorCode(rawValue: code)), animated: animated)
//    }

    private func dismissViewController(result: AtlasResult<String>, animated: Bool = true) -> Bool {
        dismissViewControllerAnimated(animated) {
            self.paymentCompletion?(result)
        }
        switch result {
        case .success:
            return true
        default:
            return false
        }
    }

    @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

private extension Selector {

    static let cancelButtonTapped = #selector(PaymentSelectionViewController.cancelButtonTapped(_:))

}
