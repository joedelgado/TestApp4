// PersistenceInteractor.swift
// Interactor for the Persistence module (VIPER)
// Maneja la lógica de negocio para persistencia de datos
import Foundation
import Security

// MARK: - Persistence Interactor Protocol
protocol PersistenceInteractorProtocol: AnyObject {
    var presenter: PersistencePresenter? { get set }
    
    // Keychain operations / Operaciones de Keychain
    func saveCredentials(username: String, password: String)
    func loadCredentials()
    
    // UserDefaults operations / Operaciones de UserDefaults
    func saveSwitchStates(switch1: Bool, switch2: Bool, switch3: Bool)
    func loadSwitchStates()
}

// MARK: - Persistence Interactor Implementation
class PersistenceInteractor: PersistenceInteractorProtocol {
    weak var presenter: PersistencePresenter?
    
    // MARK: - Constants
    private let keychainService = "com.testapp4.keychain"
    private let usernameKey = "stored_username"
    private let passwordKey = "stored_password"
    
    private let switch1Key = "switch1_enabled"
    private let switch2Key = "switch2_enabled"
    private let switch3Key = "switch3_enabled"
    
    // MARK: - Keychain Operations
    
    func saveCredentials(username: String, password: String) {
        // Save username to keychain / Guardar usuario en keychain
        let usernameSuccess = saveToKeychain(key: usernameKey, value: username)
        let passwordSuccess = saveToKeychain(key: passwordKey, value: password)
        
        if usernameSuccess && passwordSuccess {
            presenter?.didSaveCredentialsSuccessfully()
        } else {
            presenter?.didFailSavingCredentials(error: "Failed to save to Keychain")
        }
    }
    
    func loadCredentials() {
        guard let username = loadFromKeychain(key: usernameKey),
              let password = loadFromKeychain(key: passwordKey) else {
            presenter?.didFailLoadingCredentials(error: "No credentials found in Keychain")
            return
        }
        
        let credentials = KeychainCredentials(username: username, password: password)
        presenter?.didLoadCredentials(credentials)
    }
    
    // MARK: - UserDefaults Operations
    
    func saveSwitchStates(switch1: Bool, switch2: Bool, switch3: Bool) {
        UserDefaults.standard.set(switch1, forKey: switch1Key)
        UserDefaults.standard.set(switch2, forKey: switch2Key)
        UserDefaults.standard.set(switch3, forKey: switch3Key)
        
        presenter?.didSaveSwitchStatesSuccessfully()
    }
    
    func loadSwitchStates() {
        let switch1 = UserDefaults.standard.bool(forKey: switch1Key)
        let switch2 = UserDefaults.standard.bool(forKey: switch2Key)
        let switch3 = UserDefaults.standard.bool(forKey: switch3Key)
        
        let preferences = UserPreferences(
            switch1Enabled: switch1,
            switch2Enabled: switch2,
            switch3Enabled: switch3
        )
        
        presenter?.didLoadSwitchStates(preferences)
    }
    
    // MARK: - Private Keychain Helper Methods
    
    private func saveToKeychain(key: String, value: String) -> Bool {
        let valueData = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]
        
        // Delete existing item first / Eliminar elemento existente primero
        SecItemDelete(query as CFDictionary)
        
        // Add new item / Agregar nuevo elemento
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func loadFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
}

// MARK: - Data Models
struct KeychainCredentials {
    let username: String
    let password: String
}

struct UserPreferences {
    let switch1Enabled: Bool
    let switch2Enabled: Bool
    let switch3Enabled: Bool
}
