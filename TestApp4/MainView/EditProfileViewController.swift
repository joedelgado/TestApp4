// EditProfileViewController.swift
// Modal form for editing user profile
import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(name: String, age: Int, email: String, image: UIImage?)
}

class EditProfileViewController: UIViewController {
    weak var delegate: EditProfileDelegate?
    private let imageView = UIImageView()
    private let nameField = UITextField()
    private let ageField = UITextField()
    private let emailField = UITextField()
    private let selectImageButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editar Perfil"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    func setProfile(name: String, age: Int, email: String, image: UIImage?) {
        nameField.text = name
        ageField.text = "\(age)"
        emailField.text = email
        imageView.image = image ?? UIImage(systemName: "person.crop.circle.fill")
    }
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        selectImageButton.setTitle("Seleccionar Imagen", for: .normal)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        view.addSubview(selectImageButton)
        nameField.placeholder = "Nombre"
        nameField.borderStyle = .roundedRect
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        ageField.placeholder = "Edad"
        ageField.borderStyle = .roundedRect
        ageField.keyboardType = .numberPad
        ageField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ageField)
        emailField.placeholder = "Correo"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailField)
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            selectImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 16),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            ageField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 12),
            ageField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            ageField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            emailField.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: 12),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc private func selectImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc private func saveProfile() {
        guard let name = nameField.text, !name.isEmpty,
              let ageText = ageField.text, let age = Int(ageText),
              let email = emailField.text, !email.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Completa todos los campos correctamente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        delegate?.didUpdateProfile(name: name, age: age, email: email, image: selectedImage ?? imageView.image)
        dismiss(animated: true)
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            selectedImage = image
        }
        picker.dismiss(animated: true)
    }
}
