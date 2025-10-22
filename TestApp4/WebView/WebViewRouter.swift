//
//  WebViewRouter.swift
//  TestApp4
//
//  Created by Joel Delgado on 17/10/2025.
//

import UIKit

// MARK: - WebViewRouterProtocol
protocol WebViewRouterProtocol {
    static func createWebViewModule() -> UIViewController
    func navigateBack(from view: WebViewViewProtocol)
}

// MARK: - WebViewRouter
class WebViewRouter: WebViewRouterProtocol {
    // MARK: - WebViewRouterProtocol
    static func createWebViewModule() -> UIViewController {
        let view = WebViewViewController()
        let presenter = WebViewPresenter()
        let interactor = WebViewInteractor(webView: view.webView)
        let router = WebViewRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateBack(from view: WebViewViewProtocol) {
        guard let viewController = view as? UIViewController else { return }
        viewController.navigationController?.popViewController(animated: true)
    }
}
