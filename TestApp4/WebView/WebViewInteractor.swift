//
//  WebViewInteractor.swift
//  TestApp4
//
//  Created by Joel Delgado on 17/10/2025.
//

import Foundation
import WebKit

// MARK: - WebViewInteractorProtocol
protocol WebViewInteractorProtocol {
    func loadURL(_ url: URL)
    func goBack()
    func goForward()
    func reload()
    func stopLoading()
    func canGoBack() -> Bool
    func canGoForward() -> Bool
    func getCurrentURL() -> URL?
}

// MARK: - WebViewInteractor
class WebViewInteractor: NSObject, WebViewInteractorProtocol {
    // MARK: - Properties
    weak var presenter: WebViewInteractorOutputProtocol?
    private let webView: WKWebView
    
    // MARK: - Initialization
    init(webView: WKWebView) {
        self.webView = webView
        super.init()
        setupWebView()
    }
    
    // MARK: - Private Methods
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    // MARK: - WebViewInteractorProtocol
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func reload() {
        webView.reload()
    }
    
    func stopLoading() {
        webView.stopLoading()
    }
    
    func canGoBack() -> Bool {
        return webView.canGoBack
    }
    
    func canGoForward() -> Bool {
        return webView.canGoForward
    }
    
    func getCurrentURL() -> URL? {
        return webView.url
    }
}

// MARK: - WKNavigationDelegate
extension WebViewInteractor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        presenter?.didStartLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        presenter?.didFinishLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presenter?.didFailLoading(with: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        presenter?.didFailLoading(with: error)
    }
}

// MARK: - WKUIDelegate
extension WebViewInteractor: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Manejar enlaces que abren en nueva ventana
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        presenter?.showAlert(message: message, completion: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        presenter?.showConfirm(message: message, completion: completionHandler)
    }
}

// MARK: - WebViewInteractorOutputProtocol
protocol WebViewInteractorOutputProtocol: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailLoading(with error: Error)
    func showAlert(message: String, completion: @escaping () -> Void)
    func showConfirm(message: String, completion: @escaping (Bool) -> Void)
}
