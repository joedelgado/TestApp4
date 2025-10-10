// UIBien.swift
// Lógica de la vista para el módulo UIComponents siguiendo BIPER
import UIKit

protocol UIBienProtocol: AnyObject {
    func mostrarComponente()
}

class UIBien: UIBienProtocol {
    weak var viewController: UIComponentsViewController?
    
    func mostrarComponente() {
        // Implementación de la lógica de la vista
    }
}
