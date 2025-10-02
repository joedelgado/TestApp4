// UIRouter.swift
// Navegación para el módulo UIComponents siguiendo BIPER
import UIKit

protocol UIRouterProtocol: AnyObject {
    func navegarAComponenteDetalle()
}

class UIRouter: UIRouterProtocol {
    weak var viewController: UIComponentsViewController?
    
    func navegarAComponenteDetalle() {
        // Implementación de la navegación
    }
}
