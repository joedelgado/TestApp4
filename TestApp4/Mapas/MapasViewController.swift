// filepath: /Users/joeldelgado/Documents/TutorialUIKit/TestApp4/TestApp4/Mapas/MapasViewController.swift
//
//  MapasViewController.swift
//  TestApp4
//
//  Created by GitHub Copilot on 17/10/2025.
//

import UIKit
import MapKit
import CoreLocation

class MapasViewController: UIViewController {
    var presenter: MapasPresenterProtocol?
    
    // MARK: - UI Elements
    private let mapView = MKMapView()
    private let currentLocationButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMapView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Mapas"
        view.backgroundColor = .systemBackground
        
        // Setup map view
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Setup current location button
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .systemBackground
        currentLocationButton.layer.cornerRadius = 25
        currentLocationButton.layer.shadowColor = UIColor.black.cgColor
        currentLocationButton.layer.shadowOpacity = 0.3
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentLocationButton.layer.shadowRadius = 4
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.addTarget(self, action: #selector(didTapCurrentLocation), for: .touchUpInside)
        view.addSubview(currentLocationButton)
        
        // Setup loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // Constraints
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 50),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 50),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // Add long press gesture for adding annotations
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Actions
    @objc private func didTapCurrentLocation() {
        presenter?.didTapCurrentLocation()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            presenter?.didTapAddAnnotation(at: coordinate)
        }
    }
}

// MARK: - MapasViewProtocol
extension MapasViewController: MapasViewProtocol {
    func showUserLocation(_ location: CLLocation) {
        // Map view already shows user location
    }
    
    func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateMapRegion(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(_ annotation: MKPointAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
}

// MARK: - MKMapViewDelegate
extension MapasViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil // Use default user location annotation
        }
        
        let identifier = "CustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
