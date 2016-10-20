//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

final class ToCViewController: UIViewController, UIWebViewDelegate {

    private let tocURL: NSURL

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "toc-webview"
        return webView
    }()

    init(tocURL: NSURL) {
        self.tocURL = tocURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.fillInSuperView()
        webView.loadRequest(NSURLRequest(URL: tocURL))
    }

    #if swift(>=2.3)
        func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
            dismissViewController(.failure(error), animated: true)
        }
    #else
        func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
            guard let error = error where !errorBecuaseRequestCancelled(error) else { return }
            dismissViewController(.failure(error), animated: true)
        }
    #endif

    private func errorBecuaseRequestCancelled(error: NSError) -> Bool {
        return error.domain == "WebKitErrorDomain"
    }

    private func dismissViewController(result: AtlasResult<Bool>, animated: Bool = true) {
        navigationController?.popViewControllerAnimated(animated)
    }

}
