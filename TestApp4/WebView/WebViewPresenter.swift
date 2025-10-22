//
//  WebViewPresenter.swift
//  TestApp4
//
//  Created by Joel Delgado on 17/10/2025.
//

import Foundation
import WebKit

// MARK: - WebViewPresenterProtocol
protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func loadURL(_ urlString: String?)
    func goBack()
    func goForward()
    func reload()
    func stopLoading()
    func canGoBack() -> Bool
    func canGoForward() -> Bool
    func getCurrentURL() -> String?
}

// MARK: - WebViewPresenter
class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    weak var view: WebViewViewProtocol?
    var interactor: WebViewInteractorProtocol?
    var router: WebViewRouterProtocol?
    
    private let entity = WebViewEntity()
    
    // MARK: - WebViewPresenterProtocol
    func viewDidLoad() {
        view?.setupUI()
        loadDefaultURL()
    }
    
    func loadURL(_ urlString: String?) {
        guard let urlString = urlString, !urlString.isEmpty else {
            loadDefaultURL()
            return
        }
        
        guard let url = URL(string: urlString) else {
            view?.showError(WebViewEntity.WebViewError.invalidURL.localizedDescription)
            return
        }
        
        interactor?.loadURL(url)
    }
    
    func goBack() {
        interactor?.goBack()
    }
    
    func goForward() {
        interactor?.goForward()
    }
    
    func reload() {
        interactor?.reload()
    }
    
    func stopLoading() {
        interactor?.stopLoading()
        view?.hideLoading()
    }
    
    func canGoBack() -> Bool {
        return interactor?.canGoBack() ?? false
    }
    
    func canGoForward() -> Bool {
        return interactor?.canGoForward() ?? false
    }
    
    func getCurrentURL() -> String? {
        return interactor?.getCurrentURL()?.absoluteString
    }
    
    // MARK: - Private Methods
    private func loadDefaultURL() {
        interactor?.loadURL(entity.defaultURL)
    }
}

// MARK: - WebViewInteractorOutputProtocol
extension WebViewPresenter: WebViewInteractorOutputProtocol {
    func didStartLoading() {
        view?.showLoading()
    }
    
    func didFinishLoading() {
        view?.hideLoading()
        view?.updateNavigationButtons()
    }
    
    func didFailLoading(with error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func showAlert(message: String, completion: @escaping () -> Void) {
        view?.showAlert(message: message, completion: completion)
    }
    
    func showConfirm(message: String, completion: @escaping (Bool) -> Void) {
        view?.showConfirm(message: message, completion: completion)
    }
}
