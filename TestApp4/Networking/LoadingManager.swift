//
//  LoadingManager.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import UIKit

// MARK: - Loading Manager
class LoadingManager {
    static let shared = LoadingManager()
    
    private var overlayView: UIView?
    private var loadingView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    private var loadingLabel: UILabel?
    
    private init() {}
    
    // MARK: - Public Methods
    func showLoading(on viewController: UIViewController, message: String = "Cargando Pokémon...") {
        guard overlayView == nil else { return } // Avoid multiple loading views
        
        setupLoadingView(on: viewController, message: message)
        animateIn()
    }
    
    func hideLoading() {
        animateOut { [weak self] in
            self?.cleanup()
        }
    }
    
    // MARK: - Private Methods
    private func setupLoadingView(on viewController: UIViewController, message: String) {
        // Create overlay view
        overlayView = UIView(frame: viewController.view.bounds)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView?.alpha = 0
        
        // Create loading container
        loadingView = UIView()
        loadingView?.backgroundColor = .systemBackground
        loadingView?.layer.cornerRadius = 16
        loadingView?.layer.shadowColor = UIColor.black.cgColor
        loadingView?.layer.shadowOpacity = 0.3
        loadingView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        loadingView?.layer.shadowRadius = 8
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        
        // Create activity indicator (simulating Lottie animation)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .systemBlue
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.startAnimating()
        
        // Create loading label
        loadingLabel = UILabel()
        loadingLabel?.text = message
        loadingLabel?.textAlignment = .center
        loadingLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loadingLabel?.textColor = .label
        loadingLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        guard let overlayView = overlayView,
              let loadingView = loadingView,
              let activityIndicator = activityIndicator,
              let loadingLabel = loadingLabel else { return }
        
        viewController.view.addSubview(overlayView)
        overlayView.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Loading view constraints
            loadingView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 200),
            loadingView.heightAnchor.constraint(equalToConstant: 120),
            
            // Activity indicator constraints
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loadingView.topAnchor, constant: 20),
            
            // Loading label constraints
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 16),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -16)
        ])
    }
    
    private func animateIn() {
        guard let overlayView = overlayView, let loadingView = loadingView else { return }
        
        loadingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            overlayView.alpha = 1
            loadingView.transform = .identity
        }
    }
    
    private func animateOut(completion: @escaping () -> Void) {
        guard let overlayView = overlayView, let loadingView = loadingView else {
            completion()
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0
            loadingView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            completion()
        }
    }
    
    private func cleanup() {
        activityIndicator?.stopAnimating()
        overlayView?.removeFromSuperview()
        
        overlayView = nil
        loadingView = nil
        activityIndicator = nil
        loadingLabel = nil
    }
}