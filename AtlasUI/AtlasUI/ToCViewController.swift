//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias WebViewLoadedCompletion = (_ request: URL?, _ error: Error?, _ status: HTTPStatus) -> Void

final class ToCViewController: UIViewController {

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
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)

        self.title = Localizer.format(string: "termsAndConditionsView.title")

        webView.fillInSuperview()
    }

    func load(url: URL, completion: WebViewLoadedCompletion? = nil) {
        self.loadedCompletion = completion

        webView.loadRequest(prepareRequest(for: url))
    }

    private func prepareRequest(for url: URL) -> URLRequest {
        url.removeCookies()

        var request = URLRequest(url: url)
        request.setValue("AtlasSDK", forHTTPHeaderField: "X-Zalando-Mobile-App")
        return request
    }

}

extension ToCViewController: UIWebViewDelegate {

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
