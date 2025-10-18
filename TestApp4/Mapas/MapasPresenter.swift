// filepath: /Users/joeldelgado/Documents/TutorialUIKit/TestApp4/TestApp4/Mapas/MapasPresenter.swift
//
//  MapasPresenter.swift
//  TestApp4
//
//  Created by GitHub Copilot on 17/10/2025.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Protocols
protocol MapasPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillDisappear()
    func didTapCurrentLocation()
    func didTapAddAnnotation(at coordinate: CLLocationCoordinate2D)
}

protocol MapasViewProtocol: AnyObject {
    func showUserLocation(_ location: CLLocation)
    func showErrorMessage(_ message: String)
    func updateMapRegion(_ region: MKCoordinateRegion)
    func addAnnotation(_ annotation: MKPointAnnotation)
    func showLoading()
    func hideLoading()
}

// MARK: - Presenter
class MapasPresenter: MapasPresenterProtocol {
    weak var view: MapasViewProtocol?
    var interactor: MapasInteractorInputProtocol?
    var router: MapasRouterProtocol?
    
    private var currentLocation: CLLocation?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.requestUserLocation()
    }
    
    func viewWillDisappear() {
        interactor?.stopLocationUpdates()
    }
    
    func didTapCurrentLocation() {
        if let location = currentLocation {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            view?.updateMapRegion(region)
        } else {
            view?.showErrorMessage("Ubicación no disponible")
        }
    }
    
    func didTapAddAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Punto personalizado"
        annotation.subtitle = "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"
        view?.addAnnotation(annotation)
    }
}

// MARK: - MapasInteractorOutputProtocol
extension MapasPresenter: MapasInteractorOutputProtocol {
    func didUpdateLocation(_ location: CLLocation) {
        view?.hideLoading()
        currentLocation = location
        view?.showUserLocation(location)
        
        // Center map on user location
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        view?.updateMapRegion(region)
    }
    
    func didFailWithError(_ error: MapError) {
        view?.hideLoading()
        switch error {
        case .locationNotAvailable:
            view?.showErrorMessage("Ubicación no disponible")
        case .locationDenied:
            view?.showErrorMessage("Permiso de ubicación denegado. Ve a Configuración para habilitarlo.")
        case .locationRestricted:
            view?.showErrorMessage("Ubicación restringida")
        case .unknownError:
            view?.showErrorMessage("Error desconocido")
        }
    }
    
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            interactor?.requestUserLocation()
        }
    }
}