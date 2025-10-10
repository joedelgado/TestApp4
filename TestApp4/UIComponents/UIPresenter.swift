// UIPresenter.swift
// Lógica de presentación para el módulo UIComponents siguiendo BIPER
import Foundation

protocol UIPresenterProtocol: AnyObject {
    func presentarDatosComponente()
}

class UIPresenter: UIPresenterProtocol {
    weak var bien: UIBienProtocol?
    var interactor: UIInteractorProtocol?
    
    func presentarDatosComponente() {
        // Implementación de la lógica de presentación
    }
}
