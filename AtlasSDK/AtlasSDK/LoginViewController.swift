//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

typealias LoginCompletion = AtlasResult<String> -> Void
typealias WebViewFinishedLoadCompletion = UIWebView -> Void

final class LoginViewController: UIViewController {

    private let loginURL: NSURL

    private let loginCompletion: LoginCompletion?
    private var webViewFinishedLoadCompletion: WebViewFinishedLoadCompletion?
    private var webViewDidFinishedLoad = false

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

    private func dismissViewController(withFailure error: LoginError, animated: Bool = true) -> Bool {
        return dismissViewController(.failure(error), animated: animated)
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

extension LoginViewController: UIWebViewDelegate {

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

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.dismissViewController(withFailure: .requestFailed)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        webViewFinishedLoadCompletion?(webView)
        webViewDidFinishedLoad = true
    }

}

#if DEBUG
    extension LoginViewController {

        override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
            if motion == .MotionShake {
                self.login(email: "atlas-testing@mailinator.com", password: "12345678")
            }
        }

    }
#endif

extension LoginViewController {

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
