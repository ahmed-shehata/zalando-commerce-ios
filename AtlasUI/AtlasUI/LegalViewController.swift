//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias RequestSuccessfulCompletion = AtlasResult<LegalViewController>


final class LegalController: NSURLSessionDelegate {

    internal let webViewData: WebViewData

    private let legalURLPath = "/legal/"
    private let interceptedPaths = ["/"]

    func canPresentLegalViewController(forURL url: NSURL) -> Bool {
    }

    func presentLegalViewController(forURL url: NSURL, completion: RequestSuccessfulCompletion? = nil) {
    }

}


final class LegalViewController: UIViewController, UIWebViewDelegate {

    internal let webViewData: WebViewData

    private lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .whiteColor()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "legal-webview"
        return webView
    }()

    init(webViewData: WebViewData) {
        self.webViewData = webViewData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        view.addSubview(webView)

        webView.fillInSuperView()
    }

}

struct WebViewData {

    let data: NSData
    let mimeType: String
    let textEncoding: String
    let baseURL: NSURL

}
