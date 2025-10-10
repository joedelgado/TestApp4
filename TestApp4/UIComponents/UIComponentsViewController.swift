// UIComponentsViewController.swift
// Controlador principal del módulo UIComponents siguiendo BIPER
import UIKit

class UIComponentsViewController: UIViewController {
    var bien: UIBienProtocol?
    var interactor: UIInteractorProtocol?
    var presenter: UIPresenterProtocol?
    var router: UIRouterProtocol?
    
    private var textField: UITextField?
    private var switchControl: UISwitch?
    private var segmentedControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarModulo()
        configurarUI()
    }
    
    private func configurarModulo() {
        let bien = UIBien()
        let interactor = UIInteractor()
        let presenter = UIPresenter()
        let router = UIRouter()
        
        bien.viewController = self
        interactor.presenter = presenter
        presenter.bien = bien
        presenter.interactor = interactor
        router.viewController = self
        
        self.bien = bien
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }
    
    private func configurarUI() {
        view.backgroundColor = .systemBackground
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        // 1. Label
        let label = UILabel()
        label.text = "Este es un UILabel"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        stackView.addArrangedSubview(label)

        // 2. TextView (no editable, attributed text, hipervínculo)
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        let attributedString = NSMutableAttributedString(string: "Texto con propiedades y un hipervínculo: Click aquí")
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 0, length: 5))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: 5))
        let linkRange = (attributedString.string as NSString).range(of: "Click aquí")
        attributedString.addAttribute(.link, value: "https://www.google.com", range: linkRange)
        textView.attributedText = attributedString
        stackView.addArrangedSubview(textView)

        // 3. TextField
        textField = UITextField()
        textField?.borderStyle = .roundedRect
        textField?.placeholder = "Ingresa texto aquí"
        textField?.keyboardType = .default
        if let textField = textField {
            stackView.addArrangedSubview(textField)
        }

        // 4. Button (alerta con texto del textfield)
        let button = UIButton(type: .system)
        button.setTitle("Mostrar alerta", for: .normal)
        button.addTarget(self, action: #selector(mostrarAlerta(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(button)

        // 5. Switch (habilita/deshabilita edición del textfield)
        switchControl = UISwitch()
        switchControl?.isOn = true
        switchControl?.addTarget(self, action: #selector(switchEditChanged(_:)), for: .valueChanged)
        if let switchControl = switchControl {
            stackView.addArrangedSubview(switchControl)
        }

        // 6. Segmented Control (Nombre/Edad)
        segmentedControl = UISegmentedControl(items: ["Nombre", "Edad"])
        segmentedControl?.selectedSegmentIndex = 0
        segmentedControl?.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)
        if let segmentedControl = segmentedControl {
            stackView.addArrangedSubview(segmentedControl)
        }

        // 7. ImageView (imagen por defecto)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.image = UIImage(systemName: "person.crop.circle")
        stackView.addArrangedSubview(imageView)
    }
    
    @objc private func mostrarAlerta(_ sender: UIButton) {
        let texto = textField?.text ?? ""
        let alerta = UIAlertController(title: "Texto ingresado", message: texto, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    @objc private func switchEditChanged(_ sender: UISwitch) {
        textField?.isEnabled = sender.isOn
    }

    @objc private func segmentedChanged(_ sender: UISegmentedControl) {
        textField?.text = ""
        if sender.selectedSegmentIndex == 0 {
            textField?.keyboardType = .default
        } else {
            textField?.keyboardType = .numberPad
        }
        textField?.reloadInputViews()
    }
}
