//
//  NetworkingPresenter.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import Foundation

// MARK: - Protocol Definition
protocol NetworkingViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showPokemonList(_ pokemonList: [PokemonSummary])
    func showPokemonDetails(_ pokemon: Pokemon)
    func showError(_ message: String)
    func updateUI()
}

protocol NetworkingPresenterProtocol: AnyObject {
    var pokemonList: [PokemonSummary] { get }
    func viewDidLoad()
    func didTapRefresh()
    func didSelectPokemon(at index: Int)
    func didRequestDeletePokemon(at index: Int)
    func confirmDeletePokemon(at index: Int)
    func didStartLoading()
    func didStopLoading()
    func didFetchPokemonList(_ pokemonList: [PokemonSummary])
    func didFetchPokemonDetails(_ pokemon: Pokemon)
    func didFailWithError(_ error: NetworkError)
    func fetchPokemonList()
    func fetchPokemonDetails(_ pokemonName: String)
}

class NetworkingPresenter: NetworkingPresenterProtocol {
    weak var view: NetworkingViewProtocol?
    var interactor: NetworkingInteractorProtocol?
    var router: NetworkingRouterProtocol?
    
    // MARK: - Data Storage
    private(set) var pokemonList: [PokemonSummary] = []
    
    // MARK: - View Lifecycle
    func viewDidLoad() {
        view?.updateUI()
        fetchPokemonData()
    }
    
    // MARK: - User Actions
    func didTapRefresh() {
        fetchPokemonData()
    }
    
    func didSelectPokemon(at index: Int) {
        guard index < pokemonList.count else { return }
        let pokemon = pokemonList[index]
        interactor?.fetchPokemonDetails(for: pokemon)
    }
    
    func didRequestDeletePokemon(at index: Int) {
        // This functionality is handled directly in the ViewController
        // No need to call view methods here
    }
    
    func confirmDeletePokemon(at index: Int) {
        guard index < pokemonList.count else { return }
        pokemonList.remove(at: index)
        view?.updateUI()
    }
    
    // MARK: - Public Methods (Called by ViewController)
    func fetchPokemonList() {
        interactor?.fetchPokemonList()
    }
    
    func fetchPokemonDetails(_ pokemonName: String) {
        // Create a PokemonSummary object for compatibility
        let pokemonSummary = PokemonSummary(name: pokemonName, url: "")
        interactor?.fetchPokemonDetails(for: pokemonSummary)
    }
    
    // MARK: - Private Methods
    private func fetchPokemonData() {
        interactor?.fetchPokemonList()
    }
    
    // MARK: - Interactor Callbacks
    func didStartLoading() {
        view?.showLoading()
    }
    
    func didStopLoading() {
        view?.hideLoading()
    }
    
    func didFetchPokemonList(_ pokemonList: [PokemonSummary]) {
        self.pokemonList = pokemonList
        view?.showPokemonList(pokemonList)
    }
    
    func didFetchPokemonDetails(_ pokemon: Pokemon) {
        // Pass the Pokemon object directly to the view
        view?.showPokemonDetails(pokemon)
    }
    
    func didFailWithError(_ error: NetworkError) {
        view?.showError(error.description)
    }
}
