// AlbumRouter.swift
// Router for the Album module (VIPER)
// Enrutador del módulo Album
import UIKit

// MARK: - Album Router Protocol
protocol AlbumRouterProtocol: AnyObject {
    static func createAlbumModule() -> UIViewController
}

// MARK: - Album Router Implementation
class AlbumRouter: AlbumRouterProtocol {
    
    // Create Album module / Crear módulo Album
    static func createAlbumModule() -> UIViewController {
        let view = AlbumMainViewController()
        let presenter = AlbumPresenter()
        let interactor = AlbumInteractor()
        let router = AlbumRouter()
        
        // Wire up VIPER components / Conectar componentes VIPER
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
