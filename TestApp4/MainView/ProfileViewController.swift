// ProfileViewController.swift
// Profile tab for user info
import UIKit

class ProfileViewController: UIViewController {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let emailLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private var name = "Joel Delgado"
    private var age = 25
    private var email = "joel@email.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        updateProfileUI()
    }
    private func setupUI() {
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        ageLabel.font = UIFont.systemFont(ofSize: 18)
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ageLabel)
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        editButton.setTitle("Editar", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        view.addSubview(editButton)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            ageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 12),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 120),
            editButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func updateProfileUI() {
        nameLabel.text = name
        ageLabel.text = "Edad: \(age)"
        emailLabel.text = email
    }
    @objc private func editProfile() {
        let editVC = EditProfileViewController()
        editVC.delegate = self
        editVC.modalPresentationStyle = .formSheet
        editVC.setProfile(name: name, age: age, email: email, image: imageView.image)
        present(editVC, animated: true)
    }
}
extension ProfileViewController: EditProfileDelegate {
    func didUpdateProfile(name: String, age: Int, email: String, image: UIImage?) {
        self.name = name
        self.age = age
        self.email = email
        if let img = image { self.imageView.image = img }
        updateProfileUI()
    }
}
