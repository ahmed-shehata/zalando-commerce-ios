//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias WebViewLoadedCompletion = (_ request: URL?, _ error: Error?, _ status: HTTPStatus) -> Void

final class ToCViewController: UIViewController, UIWebViewDelegate {

    fileprivate var loadedCompletion: WebViewLoadedCompletion? {
        willSet {
            webView.stopLoading()
        }
    }

    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .white
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "toc-webview"
        return webView
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(webView)

        self.title = Localizer.string("termsAndConditionsView.title")

        webView.fillInSuperview()
    }

    func load(url: URL, completion: WebViewLoadedCompletion? = nil) {
        self.loadedCompletion = completion

        let request = NSMutableURLRequest(url: url)
        request.setValue("AtlasSDK", forHTTPHeaderField: "X-Zalando-Mobile-App")
        webView.loadRequest(request as URLRequest)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        didLoad(webView: webView)
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        didLoad(webView: webView, error: error)
    }

    fileprivate func didLoad(webView: UIWebView, error: Error? = nil) {
        let status: HTTPStatus = {
            guard let request = webView.request,
                let response = URLCache.shared.cachedResponse(for: request)?.response as? HTTPURLResponse
                else { return HTTPStatus.unknown }
            return HTTPStatus(response: response)
        }()

        loadedCompletion?(webView.request?.url, error, status)
    }

}
