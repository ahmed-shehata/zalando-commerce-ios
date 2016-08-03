//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasCommons

typealias LoginCompletion = AtlasResult<String> -> Void

final class LoginViewController: UIViewController, UIWebViewDelegate {

    private let loginURL: NSURL

    private let loginCompletion: LoginCompletion?

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(loginURL: NSURL, completion: LoginCompletion? = nil) {
        self.loginURL = loginURL
        self.loginCompletion = completion
        super.init(nibName: nil, bundle: nil)
        self.title = "Login with Zalando"
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
            guard let url = request.URL else {
                return dismissViewController(withFailureCode: .MissingURL)
            }

            guard !url.isAccessDenied else {
                return dismissViewController(withFailureCode: .AccessDenied)
            }

            guard let token = url.accessToken else {
                return true
            }

            return dismissViewController(.success(token))
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.dismissViewController(withFailureCode: .RequestFailed)
    }

    private func dismissViewController(withFailureCode code: LoginError.Code, animated: Bool = true) -> Bool {
        return dismissViewController(.failure(LoginError(code: code)), animated: animated)
    }

    private func dismissViewController(result: AtlasResult<String>, animated: Bool = true) -> Bool {
        dismissViewControllerAnimated(animated) {
            self.loginCompletion?(result)
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

    static let cancelButtonTapped = #selector(LoginViewController.cancelButtonTapped(_:))

}
