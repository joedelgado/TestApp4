//
//  WebViewEntity.swift
//  TestApp4
//
//  Created by Joel Delgado on 17/10/2025.
//

import Foundation
import WebKit

// MARK: - WebViewEntity
struct WebViewEntity {
    // Configuración básica para WebView
    let defaultURL: URL = URL(string: "https://www.apple.com")!
    
    // Configuración de navegación
    struct NavigationConfig {
        let allowsBackForwardNavigationGestures: Bool = true
        let allowsInlineMediaPlayback: Bool = true
        let mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes = []
    }
    
    // Estados de carga
    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(Error)
    }
    
    // Tipos de error personalizados
    enum WebViewError: Error {
        case invalidURL
        case networkError
        case loadingFailed
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "URL inválida"
            case .networkError:
                return "Error de red"
            case .loadingFailed:
                return "Error al cargar la página"
            }
        }
    }
}
