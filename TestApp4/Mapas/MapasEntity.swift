// filepath: /Users/joeldelgado/Documents/TutorialUIKit/TestApp4/TestApp4/Mapas/MapasEntity.swift
//
//  MapasEntity.swift
//  TestApp4
//
//  Created by GitHub Copilot on 17/10/2025.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Protocols
protocol MapasEntityProtocol {
    // Define any entity-related protocols if needed
}

// MARK: - Data Models
struct MapLocation {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String?
}

struct MapRegion {
    let center: CLLocationCoordinate2D
    let span: MKCoordinateSpan
}

// MARK: - Enums
enum MapError: Error {
    case locationNotAvailable
    case locationDenied
    case locationRestricted
    case unknownError
}

// MARK: - Extensions
extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
