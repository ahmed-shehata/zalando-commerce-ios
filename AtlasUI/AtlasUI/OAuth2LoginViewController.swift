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
        self.title = Localizer.string("Zalando.login")
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

    private func dismissViewController(withFailure error: LoginError, animated: Bool = true) -> Bool {
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
        dismissViewController(.failure(AtlasUserError.userCancelled))
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

#if DEBUG
    extension OAuth2LoginViewController {

        override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
            if motion == .MotionShake {
                self.login(email: "atlas-testing@mailinator.com", password: "12345678")
            }
        }

    }
#endif

extension OAuth2LoginViewController {

    func login(email email: String, password: String) {
        if webViewDidFinishedLoad {
            submit(email: email, password: password)
        } else {
            webViewFinishedLoadCompletion = { _ in
                self.submit(email: email, password: password)
            }
        }
    }

    func submit(email email: String, password: String) {
        let loginJS =
        // "$('input[type=\'email\']').value = '\(email)'"
        // + "$('input[type=\'password\']').value = '\(password)'"
        // "$('.z-button-submit').click()"

        "var inputFields = document.getElementsByTagName('input');"
            + "for (var i = inputFields.length >>> 0; i--;) {"
            + "  if (inputFields[i].type == 'email') inputFields[i].value = '\(email)';"
            + "  if (inputFields[i].type == 'password') inputFields[i].value = '\(password)';"
            + "};"
            + "document.getElementsByClassName('z-button-submit')[0].click() "

        let ret = webView.stringByEvaluatingJavaScriptFromString(loginJS)
        print("SUMBIT RESULT: ", ret)
    }

}
