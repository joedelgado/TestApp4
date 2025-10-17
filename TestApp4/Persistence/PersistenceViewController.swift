// PersistenceViewController.swift
// Persistence feature with VIPER architecture - Programmatic UI implementation
import UIKit

// MARK: - Protocol Definition
protocol PersistenceViewProtocol: AnyObject {
    func showSuccessMessage(_ message: String)
    func showErrorMessage(_ message: String)
    func displayCredentials(username: String, password: String)
    func updateSwitchStates(switch1: Bool, switch2: Bool, switch3: Bool)
}

class PersistenceViewController: UIViewController {
    
    // MARK: - VIPER Components
    var presenter: PersistencePresenterProtocol?
    var interactor: PersistenceInteractorProtocol?
    var router: PersistenceRouterProtocol?
    
    // MARK: - UI Components (Programmatic)
    private var usernameTextField: UITextField!
    private var passwordTextField: UITextField!
    private var switch1: UISwitch!
    private var switch2: UISwitch!
    private var switch3: UISwitch!
    private var resultsLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIPER()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup VIPER
    private func setupVIPER() {
        _ = PersistenceEntity()
        let interactor = PersistenceInteractor()
        let presenter = PersistencePresenter()
        let router = PersistenceRouter()
        
        // Configure VIPER connections
        self.presenter = presenter
        self.interactor = interactor
        self.router = router
        
        presenter.view = self
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
    }
    
    private func setupUI() {
        title = "Persistence"
        view.backgroundColor = .systemBackground
        createUI()
    }
    
    private func createUI() {
        // Create ScrollView for content
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Keychain Section
        let keychainLabel = UILabel()
        keychainLabel.text = "🔐 Keychain Storage"
        keychainLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(keychainLabel)
        
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Enter username"
        usernameTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(usernameTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordTextField)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("💾 Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveCredentialsButtonTapped), for: .touchUpInside)
        
        let loadButton = UIButton(type: .system)
        loadButton.setTitle("📂 Load", for: .normal)
        loadButton.backgroundColor = .systemGreen
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 8
        loadButton.addTarget(self, action: #selector(loadCredentialsButtonTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(loadButton)
        stackView.addArrangedSubview(buttonStackView)
        
        // UserDefaults Section
        let userDefaultsLabel = UILabel()
        userDefaultsLabel.text = "⚙️ UserDefaults Storage"
        userDefaultsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(userDefaultsLabel)
        
        let switch1Container = createSwitchContainer(title: "🔔 Notifications Enabled")
        switch1 = switch1Container.1
        stackView.addArrangedSubview(switch1Container.0)
        
        let switch2Container = createSwitchContainer(title: "🌙 Dark Mode Enabled")
        switch2 = switch2Container.1
        stackView.addArrangedSubview(switch2Container.0)
        
        let switch3Container = createSwitchContainer(title: "💾 Auto-Save Enabled")
        switch3 = switch3Container.1
        stackView.addArrangedSubview(switch3Container.0)
        
        // Results Section
        let resultsHeaderLabel = UILabel()
        resultsHeaderLabel.text = "📊 Results"
        resultsHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stackView.addArrangedSubview(resultsHeaderLabel)
        
        resultsLabel = UILabel()
        resultsLabel.numberOfLines = 0
        resultsLabel.text = "Ready to perform persistence operations..."
        resultsLabel.backgroundColor = .systemGray6
        resultsLabel.layer.cornerRadius = 8
        resultsLabel.layer.masksToBounds = true
        resultsLabel.textAlignment = .center
        resultsLabel.font = UIFont.systemFont(ofSize: 14)
        stackView.addArrangedSubview(resultsLabel)
        
        // Setup ScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            resultsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    private func createSwitchContainer(title: String) -> (UIView, UISwitch) {
        let container = UIView()
        let label = UILabel()
        label.text = title
        let switchControl = UISwitch()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            switchControl.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        return (container, switchControl)
    }
    
    // MARK: - Actions
    @objc private func saveCredentialsButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorMessage("Please enter both username and password")
            return
        }
        presenter?.saveCredentialsButtonTapped(username: username, password: password)
    }
    
    @objc private func loadCredentialsButtonTapped() {
        presenter?.loadCredentialsButtonTapped()
    }
    
    @objc private func switchValueChanged() {
        let switch1Value = switch1?.isOn ?? false
        let switch2Value = switch2?.isOn ?? false
        let switch3Value = switch3?.isOn ?? false
        
        presenter?.switchValueChanged(switch1: switch1Value, switch2: switch2Value, switch3: switch3Value)
    }
}

// MARK: - PersistenceViewProtocol Implementation
extension PersistenceViewController: PersistenceViewProtocol {
    func showSuccessMessage(_ message: String) {
        DispatchQueue.main.async {
            self.resultsLabel?.text = "✅ \(message)"
            self.resultsLabel?.textColor = .systemGreen
        }
    }
    
    func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.resultsLabel?.text = "❌ \(message)"
            self.resultsLabel?.textColor = .systemRed
        }
    }
    
    func displayCredentials(username: String, password: String) {
        DispatchQueue.main.async {
            self.usernameTextField?.text = username
            self.passwordTextField?.text = password
        }
    }
    
    func updateSwitchStates(switch1: Bool, switch2: Bool, switch3: Bool) {
        DispatchQueue.main.async {
            self.switch1?.isOn = switch1
            self.switch2?.isOn = switch2
            self.switch3?.isOn = switch3
        }
    }
}
