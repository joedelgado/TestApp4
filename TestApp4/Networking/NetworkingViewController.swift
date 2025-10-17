//
//  NetworkingViewController.swift
//  TestApp4
//
//  Created by GitHub Copilot on 15/10/2025.
//

import UIKit

class NetworkingViewController: UIViewController {
    var presenter: NetworkingPresenterProtocol?
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Data
    private var pokemonList: [PokemonSummary] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadPokemonData()
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Pokémon Network"
        view.backgroundColor = .systemBackground
        
        // Add navigation bar button for manual refresh
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapRefresh)
        )
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        
        // Register custom cell
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadPokemonData() {
        // Show loading animation using LoadingManager
        LoadingManager.shared.showLoading(on: self, message: "Cargando Pokémon...")
        
        // Call presenter to fetch Pokemon data
        presenter?.fetchPokemonList()
    }
    
    // MARK: - Actions
    @objc private func didTapRefresh() {
        loadPokemonData()
    }
    
    @objc private func didPullToRefresh() {
        presenter?.fetchPokemonList()
    }
    
    // MARK: - Helper Methods
    private func showDeleteConfirmation(for pokemon: PokemonSummary, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Eliminar Pokémon",
            message: "¿Estás seguro de que quieres eliminar a \(pokemon.name.capitalized)?",
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.deletePokemon(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // For iPad compatibility
        if let popover = alert.popoverPresentationController {
            popover.sourceView = tableView
            popover.sourceRect = tableView.rectForRow(at: indexPath)
        }
        
        present(alert, animated: true)
    }
    
    private func deletePokemon(at indexPath: IndexPath) {
        pokemonList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        // Show success message
        let successAlert = UIAlertController(
            title: "Eliminado",
            message: "Pokémon eliminado exitosamente",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NetworkingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier, for: indexPath) as! PokemonTableViewCell
        let pokemon = pokemonList[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NetworkingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = pokemonList[indexPath.row]
        
        // Show loading while fetching details
        LoadingManager.shared.showLoading(on: self, message: "Cargando detalles de \(pokemon.name.capitalized)...")
        
        // Fetch Pokemon details
        presenter?.fetchPokemonDetails(pokemon.name)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pokemon = pokemonList[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            self?.showDeleteConfirmation(for: pokemon, at: indexPath)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NetworkingViewProtocol Implementation
extension NetworkingViewController: NetworkingViewProtocol {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            LoadingManager.shared.showLoading(on: self, message: "Cargando...")
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            LoadingManager.shared.hideLoading()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showPokemonList(_ pokemon: [PokemonSummary]) {
        DispatchQueue.main.async { [weak self] in
            self?.pokemonList = pokemon
            self?.tableView.reloadData()
            LoadingManager.shared.hideLoading()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showPokemonDetails(_ pokemon: Pokemon) {
        DispatchQueue.main.async { [weak self] in
            LoadingManager.shared.hideLoading()
            
            let detailText = """
            🎯 DETALLES DE POKÉMON
            
            Nombre: \(pokemon.name.capitalized)
            ID: #\(pokemon.id)
            Altura: \(Double(pokemon.height) / 10.0) m
            Peso: \(Double(pokemon.weight) / 10.0) kg
            
            Tipos: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))
            
            Habilidades: \(pokemon.abilities.map { $0.ability.name.capitalized }.joined(separator: ", "))
            """
            
            let alert = UIAlertController(
                title: "Detalles del Pokémon",
                message: detailText,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cerrar", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            LoadingManager.shared.hideLoading()
            self?.refreshControl.endRefreshing()
            
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Custom Pokemon Table View Cell
class PokemonTableViewCell: UITableViewCell {
    static let identifier = "PokemonTableViewCell"
    
    // MARK: - UI Elements
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        // Add subviews
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(urlLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Pokemon image constraints
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 60),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Stack view constraints
            stackView.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    func configure(with pokemon: PokemonSummary) {
        nameLabel.text = pokemon.name.capitalized
        urlLabel.text = pokemon.url
        
        // Set a placeholder Pokemon icon based on name
        let pokemonIcon = getPokemonIcon(for: pokemon.name)
        pokemonImageView.image = UIImage(systemName: pokemonIcon)
        pokemonImageView.tintColor = getPokemonColor(for: pokemon.name)
    }
    
    // MARK: - Helper Methods
    private func getPokemonIcon(for name: String) -> String {
        // Return different SF Symbols based on Pokemon name patterns
        let lowercaseName = name.lowercased()
        
        if lowercaseName.contains("fire") || lowercaseName.contains("char") {
            return "flame.fill"
        } else if lowercaseName.contains("water") || lowercaseName.contains("squir") {
            return "drop.fill"
        } else if lowercaseName.contains("grass") || lowercaseName.contains("bulb") {
            return "leaf.fill"
        } else if lowercaseName.contains("electric") || lowercaseName.contains("pika") {
            return "bolt.fill"
        } else if lowercaseName.contains("ice") {
            return "snowflake"
        } else if lowercaseName.contains("rock") || lowercaseName.contains("ground") {
            return "mountain.2.fill"
        } else if lowercaseName.contains("flying") || lowercaseName.contains("bird") {
            return "bird.fill"
        } else if lowercaseName.contains("bug") {
            return "ant.fill"
        } else if lowercaseName.contains("poison") {
            return "drop.triangle.fill"
        } else {
            return "star.fill"
        }
    }
    
    private func getPokemonColor(for name: String) -> UIColor {
        // Return different colors based on Pokemon name patterns
        let lowercaseName = name.lowercased()
        
        if lowercaseName.contains("fire") || lowercaseName.contains("char") {
            return .systemRed
        } else if lowercaseName.contains("water") || lowercaseName.contains("squir") {
            return .systemBlue
        } else if lowercaseName.contains("grass") || lowercaseName.contains("bulb") {
            return .systemGreen
        } else if lowercaseName.contains("electric") || lowercaseName.contains("pika") {
            return .systemYellow
        } else if lowercaseName.contains("ice") {
            return .systemCyan
        } else if lowercaseName.contains("rock") || lowercaseName.contains("ground") {
            return .systemBrown
        } else if lowercaseName.contains("flying") || lowercaseName.contains("bird") {
            return .systemIndigo
        } else if lowercaseName.contains("bug") {
            return .systemGreen
        } else if lowercaseName.contains("poison") {
            return .systemPurple
        } else {
            return .systemOrange
        }
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        urlLabel.text = nil
        pokemonImageView.image = nil
        pokemonImageView.tintColor = .systemBlue
    }
}
