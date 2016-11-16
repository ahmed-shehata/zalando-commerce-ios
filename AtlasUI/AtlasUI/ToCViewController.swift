//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

typealias WebViewLoadedCompletion = (request: NSURL?, error: NSError?, status: HTTPStatus) -> Void

final class ToCViewController: UIViewController, UIWebViewDelegate {

    private var loadedCompletion: WebViewLoadedCompletion? {
        willSet {
            webView.stopLoading()
        }
    }

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "toc-webview"
        return webView
    }()

    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        self.title = Localizer.string("termsAndConditionsView.title")

        webView.fillInSuperView()
    }

    func load(url url: NSURL, completion: WebViewLoadedCompletion? = nil) {
        self.loadedCompletion = completion

        let request = NSMutableURLRequest(URL: url)
        request.setValue("AtlasSDK", forHTTPHeaderField: "X-Zalando-Mobile-App")
        webView.loadRequest(request)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        didLoad(webView: webView)
    }

    #if swift(>=2.3)
        func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
            didLoad(webView: webView, error: error)
        }
    #else
        func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
            guard let error = error else { return }
            didLoad(webView: webView, error: error)
        }
    #endif

    private func didLoad(webView webView: UIWebView, error: NSError? = nil) {
        let status: HTTPStatus = {
            guard let request = webView.request,
                response = NSURLCache.sharedURLCache().cachedResponseForRequest(request)?.response as? NSHTTPURLResponse
                else { return HTTPStatus.Unknown }
            return HTTPStatus(response: response)
        }()

        loadedCompletion?(request: webView.request?.URL, error: error, status: status)
    }

}
