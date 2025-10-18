// filepath: /Users/joeldelgado/Documents/TutorialUIKit/TestApp4/TestApp4/Mapas/MapasInteractor.swift
//
//  MapasInteractor.swift
//  TestApp4
//
//  Created by GitHub Copilot on 17/10/2025.
//

import Foundation
import CoreLocation

// MARK: - Protocols
protocol MapasInteractorInputProtocol: AnyObject {
    func requestUserLocation()
    func stopLocationUpdates()
}

protocol MapasInteractorOutputProtocol: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
    func didFailWithError(_ error: MapError)
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus)
}

// MARK: - Interactor
class MapasInteractor: NSObject, MapasInteractorInputProtocol {
    weak var presenter: MapasInteractorOutputProtocol?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    func requestUserLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            presenter?.didFailWithError(.locationDenied)
        @unknown default:
            presenter?.didFailWithError(.unknownError)
        }
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension MapasInteractor: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        presenter?.didUpdateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        presenter?.didFailWithError(.locationNotAvailable)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenter?.didChangeAuthorizationStatus(status)
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            presenter?.didFailWithError(.locationDenied)
        }
    }
}