//
//  NetworkingRouter.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import UIKit

protocol NetworkingRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateBack(from view: NetworkingViewProtocol)
}

class NetworkingRouter: NetworkingRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = NetworkingViewController()
        let presenter = NetworkingPresenter()
        let interactor = NetworkingInteractor()
        let router = NetworkingRouter()
        
        // VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateBack(from view: NetworkingViewProtocol) {
        guard let viewController = viewController else { return }
        viewController.navigationController?.popViewController(animated: true)
    }
}