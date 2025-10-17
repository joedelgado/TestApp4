//
//  NetworkingEntity.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import Foundation

// MARK: - Pokemon API Response Models
struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonSummary]
}

struct PokemonSummary: Codable {
    let name: String
    let url: String
}

struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonTypeElement]
    let abilities: [PokemonAbilityElement]
}

struct PokemonSprites: Codable {
    let front_default: String?
}

struct PokemonTypeElement: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonAbilityElement: Codable {
    let ability: PokemonAbility
}

struct PokemonAbility: Codable {
    let name: String
}

// MARK: - Network Types
enum NetworkResult<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Error {
    case invalidURL
    case networkError(String)
    case serverError(Int)
    case noData
    case decodingError
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let message):
            return "Error de red: \(message)"
        case .serverError(let code):
            return "Error del servidor: \(code)"
        case .noData:
            return "No se recibieron datos"
        case .decodingError:
            return "Error al procesar los datos"
        }
    }
}
