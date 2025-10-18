// filepath: /Users/joeldelgado/Documents/TutorialUIKit/TestApp4/TestApp4/Mapas/MapasRouter.swift
//
//  MapasRouter.swift
//  TestApp4
//
//  Created by GitHub Copilot on 17/10/2025.
//

import UIKit

// MARK: - Protocols
protocol MapasRouterProtocol: AnyObject {
    static func createMapasModule() -> UIViewController
    func navigateBack(from view: MapasViewProtocol)
}

// MARK: - Router
class MapasRouter: MapasRouterProtocol {
    static func createMapasModule() -> UIViewController {
        let view = MapasViewController()
        let presenter = MapasPresenter()
        let interactor = MapasInteractor()
        let router = MapasRouter()
        
        // Connect VIPER components
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateBack(from view: MapasViewProtocol) {
        guard let viewController = view as? UIViewController else { return }
        viewController.navigationController?.popViewController(animated: true)
    }
}