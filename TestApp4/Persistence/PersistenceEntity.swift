// PersistenceEntity.swift
// Entity for the Persistence module (VIPER)
// Modelos de datos del módulo Persistence
import Foundation

// MARK: - Persistence Entity Protocol
protocol PersistenceEntityProtocol: AnyObject {
    // Entity methods if needed / Métodos de entidad si son necesarios
}

// MARK: - Persistence Entity Implementation
class PersistenceEntity: PersistenceEntityProtocol {
    // Entity implementation / Implementación de entidad
}

// MARK: - Data Models / Modelos de datos

// Keychain Credentials Model / Modelo de credenciales del Keychain
struct PersistenceCredentials {
    let username: String
    let password: String
    let service: String
    
    init(username: String, password: String, service: String = "com.testapp4.keychain") {
        self.username = username
        self.password = password
        self.service = service
    }
}

// UserDefaults Preferences Model / Modelo de preferencias de UserDefaults
struct PersistencePreferences {
    let switch1Enabled: Bool
    let switch2Enabled: Bool
    let switch3Enabled: Bool
    let lastUpdated: Date
    
    init(switch1: Bool = false, switch2: Bool = false, switch3: Bool = false) {
        self.switch1Enabled = switch1
        self.switch2Enabled = switch2
        self.switch3Enabled = switch3
        self.lastUpdated = Date()
    }
}

// Storage Type Enum / Enumeración de tipos de almacenamiento
enum StorageType {
    case keychain
    case userDefaults
    case both
    
    var displayName: String {
        switch self {
        case .keychain:
            return "🔐 Keychain"
        case .userDefaults:
            return "💾 UserDefaults"
        case .both:
            return "🔄 Both Storages"
        }
    }
}

// Operation Result / Resultado de operación
enum PersistenceResult<T> {
    case success(T)
    case failure(PersistenceError)
}

// Persistence Errors / Errores de persistencia
enum PersistenceError: Error, LocalizedError {
    case keychainSaveError
    case keychainLoadError
    case keychainDeleteError
    case userDefaultsSaveError
    case userDefaultsLoadError
    case invalidData
    case emptyCredentials
    
    var errorDescription: String? {
        switch self {
        case .keychainSaveError:
            return "Failed to save data to Keychain"
        case .keychainLoadError:
            return "Failed to load data from Keychain"
        case .keychainDeleteError:
            return "Failed to delete data from Keychain"
        case .userDefaultsSaveError:
            return "Failed to save data to UserDefaults"
        case .userDefaultsLoadError:
            return "Failed to load data from UserDefaults"
        case .invalidData:
            return "Invalid data provided"
        case .emptyCredentials:
            return "Username and password cannot be empty"
        }
    }
}
