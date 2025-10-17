// PersistencePresenter.swift
// Presenter for the Persistence module (VIPER)
// Lógica de presentación del módulo Persistence
import Foundation

// MARK: - Persistence Interactor Output Protocol
protocol PersistenceInteractorOutputProtocol: AnyObject {
    // Keychain Results / Resultados del Keychain
    func didSaveCredentialsSuccessfully()
    func didFailSavingCredentials(error: String)
    func didLoadCredentials(_ credentials: KeychainCredentials)
    func didFailLoadingCredentials(error: String)
    
    // UserDefaults Results / Resultados de UserDefaults
    func didSaveSwitchStatesSuccessfully()
    func didLoadSwitchStates(_ preferences: UserPreferences)
}

// MARK: - Persistence Presenter Protocol
protocol PersistencePresenterProtocol: AnyObject {
    var view: PersistenceViewProtocol? { get set }
    var interactor: PersistenceInteractorProtocol? { get set }
    var router: PersistenceRouterProtocol? { get set }
    
    // View events / Eventos de la vista
    func viewDidLoad()
    func saveCredentialsButtonTapped(username: String, password: String)
    func loadCredentialsButtonTapped()
    func switchValueChanged(switch1: Bool, switch2: Bool, switch3: Bool)
}

// MARK: - Persistence Presenter Implementation
class PersistencePresenter: PersistencePresenterProtocol {
    weak var view: PersistenceViewProtocol?
    var interactor: PersistenceInteractorProtocol?
    var router: PersistenceRouterProtocol?
    
    // MARK: - View Events / Eventos de la vista
    
    func viewDidLoad() {
        // Load initial switch states / Cargar estados iniciales de switches
        interactor?.loadSwitchStates()
    }
    
    func saveCredentialsButtonTapped(username: String, password: String) {
        // Validate and save credentials / Validar y guardar credenciales
        interactor?.saveCredentials(username: username, password: password)
    }
    
    func loadCredentialsButtonTapped() {
        // Load credentials from Keychain / Cargar credenciales del Keychain
        interactor?.loadCredentials()
    }
    
    func switchValueChanged(switch1: Bool, switch2: Bool, switch3: Bool) {
        // Save switch states automatically / Guardar estados de switches automáticamente
        interactor?.saveSwitchStates(switch1: switch1, switch2: switch2, switch3: switch3)
    }
}

// MARK: - Interactor Output Protocol
extension PersistencePresenter: PersistenceInteractorOutputProtocol {
    
    // MARK: - Keychain Results / Resultados del Keychain
    
    func didSaveCredentialsSuccessfully() {
        view?.showSuccessMessage("Credentials saved successfully to Keychain")
    }
    
    func didFailSavingCredentials(error: String) {
        view?.showErrorMessage("Error saving credentials: \(error)")
    }
    
    func didLoadCredentials(_ credentials: KeychainCredentials) {
        view?.displayCredentials(username: credentials.username, password: credentials.password)
    }
    
    func didFailLoadingCredentials(error: String) {
        view?.showErrorMessage("Error loading credentials: \(error)")
    }
    
    // MARK: - UserDefaults Results / Resultados de UserDefaults
    
    func didSaveSwitchStatesSuccessfully() {
        // Switch states saved automatically, no need to show message
        // Estados de switches guardados automáticamente, no necesita mostrar mensaje
    }
    
    func didLoadSwitchStates(_ preferences: UserPreferences) {
        view?.updateSwitchStates(
            switch1: preferences.switch1Enabled,
            switch2: preferences.switch2Enabled,
            switch3: preferences.switch3Enabled
        )
    }
}
