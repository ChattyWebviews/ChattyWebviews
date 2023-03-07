//
//  CWViewController.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 14.02.23.
//

import UIKit
import WebKit

public struct CWMessage {
    public let topic: String
    public let body: NSDictionary?
    
    public init(topic: String, body: NSDictionary?) {
        self.topic = topic
        self.body = body
    }
}

public protocol CWMessageDelegate {
    func controller(_ controller: CWViewController, didReceive message: CWMessage)
}

public class CWViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    
    var webview: WKWebView!
    var path: String?
    var assetHandler: CWAssetHandler!
    
    public var messageDelegate: CWMessageDelegate?
    
    var prepared = false

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url = "cw://localhost" + (path ?? "")
        
        if !prepared {
            prepareWebView(with: assetHandler)
            setupView()
            configureWebview()
            webview.load(URLRequest(url: URL(string: url)!))
            prepared = true
        }
        
    }
    
    func configure(folderName: String, path: String?) {
        let configuration = InstanceConfiguration(folderName: folderName)
        assetHandler = CWAssetHandler(router: _Router())
        assetHandler.setAssetPath(configuration._appLocation.path)
        
        self.path = path
    }

    public func sendMessage(_ message: CWMessage) {
        guard let jsonData = try? JSONSerialization.data(
            withJSONObject: message.body,
            options: []) else {
            print("MESSAGE ERROR: Message serialization failed")
            return
        }
        
        let jsonText = String(data: jsonData,
                              encoding: .utf8)!
        let script = """
        window['publish']('\(message.topic)', \(jsonText));
        """
        
        webview.evaluateJavaScript(script) { (result, error) in
            if let result = result {
                print("Label is updated with message: \(result)")
            } else if let error = error {
                print("An error occurred: \(error)")
            }
        }
    }

    private func setupView() {
        view.addSubview(webview)
        webview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webview.topAnchor.constraint(equalTo: view.topAnchor),
            webview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        view.setNeedsLayout()
        view.setNeedsDisplay()
        webview.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    
    private func prepareWebView(with assetHandler: CWAssetHandler) {
        // set the cookie policy
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        // setup the web view configuration
        let webConfig = webViewConfiguration()
        webConfig.setURLSchemeHandler(assetHandler, forURLScheme:InstanceDescriptorDefaults.scheme)
        // create the web view and set its properties
        let aWebView = webView(with: view.frame, configuration: webConfig)
        aWebView.scrollView.bounces = false
        aWebView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        // set our ivar
        webview = aWebView
        
    }
    
    func webView(with frame: CGRect, configuration: WKWebViewConfiguration) -> WKWebView {
        return WKWebView(frame: frame, configuration: configuration)
    }
    
    func configureWebview() {
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        webview.configuration.userContentController.add(self, name: "cwMessageHandler")
        
    }
    
    func webViewConfiguration() -> WKWebViewConfiguration {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.suppressesIncrementalRendering = false
        webViewConfiguration.allowsAirPlayForMediaPlayback = true
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        return webViewConfiguration
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        

        if (message.name == "cwMessageHandler") {
            if let dict = message.body as? NSDictionary,
            let topic = dict["topic"] as? String{
                messageDelegate?.controller(self, didReceive: CWMessage(topic: topic, body: dict["message"] as? NSDictionary))
            } else {
                print("No object detected in message handler")
            }
            
        }
        
        
    }
    

}
