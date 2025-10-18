// MainViewController.swift
// Main tab for features list
import UIKit

// MARK: - Feature Model
class Feature {
    let title: String
    let description: String
    let icon: String
    let destination: UIViewController.Type
    init(title: String, description: String, icon: String, destination: UIViewController.Type) {
        self.title = title
        self.description = description
        self.icon = icon
        self.destination = destination
    }
}

// MARK: - Feature Cell
class FeatureCell: UITableViewCell {
    static let identifier = "FeatureCell"
    let cardView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }
    private func setupUI() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        cardView.addSubview(iconView)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    func configure(with feature: Feature) {
        titleLabel.text = feature.title
        descriptionLabel.text = feature.description
        iconView.image = UIImage(systemName: feature.icon)
    }
}

// MARK: - Main View Controller
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView(frame: .zero, style: .plain)
    let features: [Feature] = [
        Feature(title: "UI Components", description: "Explora los componentes de UIKit", icon: "rectangle.stack", destination: UIComponentsViewController.self),
        Feature(title: "Album", description: "Visualiza y selecciona imágenes", icon: "photo.on.rectangle", destination: AlbumMainViewController.self),
        Feature(title: "Persistencia", description: "Guarda datos en Keychain y UserDefaults", icon: "lock.shield", destination: PersistenceViewController.self),
        Feature(title: "Networking", description: "Consume APIs y muestra animaciones", icon: "network", destination: NetworkingViewController.self),
        Feature(title: "Mapas", description: "Explora ubicaciones en MapKit", icon: "map", destination: MapasViewController.self),
        Feature(title: "WebView", description: "Navega páginas web con WKWebView", icon: "safari", destination: WebViewViewController.self)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Features"
        view.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeatureCell.self, forCellReuseIdentifier: FeatureCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureCell.identifier, for: indexPath) as! FeatureCell
        cell.configure(with: features[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feature = features[indexPath.row]
        
        var viewController: UIViewController
        
        // Handle special cases with VIPER modules / Manejar casos especiales con módulos VIPER
        if feature.destination == AlbumMainViewController.self {
            viewController = AlbumRouter.createAlbumModule()
        } else if feature.destination == PersistenceViewController.self {
            // Create PersistenceViewController with programmatic UI
            // Crear PersistenceViewController con UI programática
            viewController = PersistenceViewController()
        } else if feature.destination == NetworkingViewController.self {
            // Create NetworkingViewController with VIPER architecture
            // Crear NetworkingViewController con arquitectura VIPER
            viewController = NetworkingRouter.createModule()
        } else if feature.destination == MapasViewController.self {
            // Create MapasViewController with VIPER architecture
            // Crear MapasViewController con arquitectura VIPER
            viewController = MapasRouter.createMapasModule()
        } else if feature.destination == WebViewViewController.self {
            // Create WebViewViewController with VIPER architecture
            // Crear WebViewViewController con arquitectura VIPER
            viewController = WebViewRouter.createWebViewModule()
        } else {
            viewController = feature.destination.init()
        }
        
        // Navigate to feature / Navegar al feature
        navigationController?.pushViewController(viewController, animated: true)
    }
}
