// UIInteractor.swift
// Lógica de negocio para el módulo UIComponents siguiendo BIPER
import Foundation

protocol UIInteractorProtocol: AnyObject {
    func obtenerDatosComponente()
}

class UIInteractor: UIInteractorProtocol {
    var presenter: UIPresenterProtocol?
    
    func obtenerDatosComponente() {
        // Implementación de la lógica de negocio
    }
}
