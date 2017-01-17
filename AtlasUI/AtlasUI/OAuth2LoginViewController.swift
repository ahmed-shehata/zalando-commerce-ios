//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias WebViewFinishedLoadCompletion = (UIWebView) -> Void
typealias AuthorizationResult = AtlasResult<AuthorizationToken>

final class OAuth2LoginViewController: UIViewController {

    fileprivate let loginURL: URL

    fileprivate let loginCompletion: AuthorizationCompletion?
    fileprivate var webViewFinishedLoadCompletion: WebViewFinishedLoadCompletion?
    fileprivate var webViewDidFinishedLoad = false

    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .white
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(loginURL: URL, completion: AuthorizationCompletion? = nil) {
        self.loginURL = loginURL
        self.loginCompletion = completion
        super.init(nibName: nil, bundle: nil)
        self.title = Localizer.format(string: "loginView.loginWithZalando")
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: .cancelButtonTapped)
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.fillInSuperview()

        webView.loadRequest(URLRequest(url: loginURL, config: AtlasAPIClient.shared?.config))
    }

    @discardableResult
    fileprivate func dismissViewController(withFailure error: AtlasLoginError, animated: Bool = true) -> Bool {
        return dismissViewController(with: .failure(error), animated: animated)
    }

    fileprivate func dismissViewController(with result: AuthorizationResult, animated: Bool = true) -> Bool {
        dismiss(animated: animated) {
            self.loginCompletion?(result)
        }
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    @objc
    fileprivate func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

}

extension OAuth2LoginViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else {
            return dismissViewController(withFailure: .missingURL)
        }

        guard !url.isAccessDenied else {
            return dismissViewController(withFailure: .accessDenied)
        }

        guard let token = url.accessToken else {
            return true
        }

        return dismissViewController(with: .success(token))
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.dismissViewController(withFailure: .requestFailed(error: error))
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewFinishedLoadCompletion?(webView)
        webViewDidFinishedLoad = true
    }

}

private extension Selector {

    static let cancelButtonTapped = #selector(OAuth2LoginViewController.cancelButtonTapped)

}
