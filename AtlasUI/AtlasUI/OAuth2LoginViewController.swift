//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias WebViewFinishedLoadCompletion = UIWebView -> Void
typealias AuthorizationResult = AtlasResult<AuthorizationToken>

final class OAuth2LoginViewController: UIViewController {

    private let loginURL: NSURL

    private let loginCompletion: AuthorizationCompletion?
    private var webViewFinishedLoadCompletion: WebViewFinishedLoadCompletion?
    private var webViewDidFinishedLoad = false

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(loginURL: NSURL, completion: AuthorizationCompletion? = nil) {
        self.loginURL = loginURL
        self.loginCompletion = completion
        super.init(nibName: nil, bundle: nil)
        self.title = Localizer.string("loginView.loginWithZalando")
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

    private func dismissViewController(withFailure error: AtlasLoginError, animated: Bool = true) -> Bool {
        return dismissViewController(.failure(error), animated: animated)
    }

    private func dismissViewController(result: AuthorizationResult, animated: Bool = true) -> Bool {
        dismissViewControllerAnimated(animated) {
            self.loginCompletion?(result)
        }
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    @objc private func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

private extension Selector {

    static let cancelButtonTapped = #selector(OAuth2LoginViewController.cancelButtonTapped(_:))

}

extension OAuth2LoginViewController: UIWebViewDelegate {

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            guard let url = request.URL else {
                return dismissViewController(withFailure: .missingURL)
            }

            guard !url.isAccessDenied else {
                return dismissViewController(withFailure: .accessDenied)
            }

            guard let token = url.accessToken else {
                return true
            }

            return dismissViewController(.success(token))
    }

    #if swift(>=2.3)
        func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
            self.dismissViewController(withFailure: .requestFailed(error: error))
        }
    #else
        func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
            self.dismissViewController(withFailure: .requestFailed(error: error))
        }
    #endif

    func webViewDidFinishLoad(webView: UIWebView) {
        webViewFinishedLoadCompletion?(webView)
        webViewDidFinishedLoad = true
    }

}
