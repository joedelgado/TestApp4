//
//  NetworkingInteractor.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import Foundation

protocol NetworkingInteractorProtocol: AnyObject {
    func fetchPokemonList()
    func fetchPokemonDetails(for pokemon: PokemonSummary)
}

class NetworkingInteractor: NetworkingInteractorProtocol {
    weak var presenter: NetworkingPresenterProtocol?
    
    // MARK: - API Endpoints
    private let baseURL = "https://pokeapi.co/api/v2"
    
    // MARK: - Public Methods
    func fetchPokemonList() {
        presenter?.didStartLoading()
        let endpoint = "/pokemon?limit=20&offset=0"
        
        performRequest(endpoint: endpoint, type: PokemonListResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.presenter?.didStopLoading()
                switch result {
                case .success(let response):
                    self?.presenter?.didFetchPokemonList(response.results)
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func fetchPokemonDetails(for pokemon: PokemonSummary) {
        presenter?.didStartLoading()
        
        // Extract Pokemon ID from URL
        let components = pokemon.url.components(separatedBy: "/")
        guard let idString = components.dropLast().last, let id = Int(idString) else {
            presenter?.didFailWithError(.invalidURL)
            return
        }
        
        let endpoint = "/pokemon/\(id)"
        performRequest(endpoint: endpoint, type: Pokemon.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.presenter?.didStopLoading()
                switch result {
                case .success(let pokemon):
                    self?.presenter?.didFetchPokemonDetails(pokemon)
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func performRequest<T: Codable>(endpoint: String, type: T.Type, completion: @escaping (NetworkResult<T>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError("Respuesta inválida")))
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
