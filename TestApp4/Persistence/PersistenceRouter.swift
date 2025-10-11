// PersistenceRouter.swift
// Router for the Persistence module (VIPER)
// Maneja la navegación y routing del módulo Persistence
import UIKit

// MARK: - Persistence Router Protocol
protocol PersistenceRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func showAlert(title: String, message: String)
    func dismissView()
}

// MARK: - Persistence Router Implementation
class PersistenceRouter: PersistenceRouterProtocol {
    weak var viewController: UIViewController?
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        // Create the Storyboard instance / Crear instancia del Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate the view controller from Storyboard / Instanciar el view controller del Storyboard
        guard let view = storyboard.instantiateViewController(withIdentifier: "PersistenceViewController") as? PersistenceViewController else {
            fatalError("PersistenceViewController not found in Storyboard")
        }
        
        // Create VIPER components / Crear componentes VIPER
        _ = PersistenceEntity()
        let interactor = PersistenceInteractor()
        let presenter = PersistencePresenter()
        let router = PersistenceRouter()
        
        // Configure VIPER connections / Configurar conexiones VIPER
        view.presenter = presenter
        view.interactor = interactor
        view.router = router
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    // MARK: - Navigation Methods
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
