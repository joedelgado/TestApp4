//
//  WebViewViewController.swift
//  TestApp4
//
//  Created by AI Assistant on 17/10/2025.
//

import UIKit
import WebKit

// MARK: - WebViewViewProtocol
protocol WebViewViewProtocol: AnyObject {
    func setupUI()
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateNavigationButtons()
    func showAlert(message: String, completion: @escaping () -> Void)
    func showConfirm(message: String, completion: @escaping (Bool) -> Void)
}

// MARK: - WebViewViewController
class WebViewViewController: UIViewController, WebViewViewProtocol {
    // MARK: - Properties
    var presenter: WebViewPresenterProtocol?
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        button.isEnabled = false
        return button
    }()
    
    private lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forwardButtonTapped))
        button.isEnabled = false
        return button
    }()
    
    private lazy var reloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadButtonTapped))
        return button
    }()
    
    private lazy var stopButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(stopButtonTapped))
        return button
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ingresa URL"
        textField.returnKeyType = .go
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: - WebViewViewProtocol
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "WebView"
        
        setupNavigationBar()
        setupToolbar()
        setupWebView()
        setupLoadingIndicator()
        setupConstraints()
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateNavigationButtons() {
        backButton.isEnabled = presenter?.canGoBack() ?? false
        forwardButton.isEnabled = presenter?.canGoForward() ?? false
        urlTextField.text = presenter?.getCurrentURL()
    }
    
    func showAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion() })
        present(alert, animated: true)
    }
    
    func showConfirm(message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion(true) })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion(false) })
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Atrás", style: .plain, target: self, action: #selector(backToMainTapped))
    }
    
    private func setupToolbar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, stopButton]
        view.addSubview(toolbar)
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        view.addSubview(urlTextField)
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 40),
            
            webView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func backToMainTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        presenter?.goBack()
    }
    
    @objc private func forwardButtonTapped() {
        presenter?.goForward()
    }
    
    @objc private func reloadButtonTapped() {
        presenter?.reload()
    }
    
    @objc private func stopButtonTapped() {
        presenter?.stopLoading()
    }
}

// MARK: - UITextFieldDelegate
extension WebViewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.loadURL(textField.text)
        textField.resignFirstResponder()
        return true
    }
}