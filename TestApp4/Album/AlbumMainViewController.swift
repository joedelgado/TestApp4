// AlbumMainViewController.swift
// View for the Album module (VIPER)
// Vista principal del módulo Album
import UIKit

// MARK: - Album View Protocol
protocol AlbumViewProtocol: AnyObject {
    func showImages(_ images: [AlbumImageEntity])
    func showSelectedImage(_ image: AlbumImageEntity)
}

// MARK: - Album Collection View Cell
class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with image: AlbumImageEntity) {
        imageView.image = UIImage(systemName: image.imageName)
    }
}

// MARK: - Album Main View Controller
class AlbumMainViewController: UIViewController, AlbumViewProtocol {
    var presenter: AlbumPresenterProtocol?
    
    // UI Components / Componentes de UI
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumCollectionViewCell.self,
                               forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        return collectionView
    }()
    
    private var albumImages: [AlbumImageEntity] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Album"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainImageView)
        view.addSubview(collectionView)
        
        // Layout constraints / Restricciones de diseño
        NSLayoutConstraint.activate([
            // Main image view - upper half / Vista principal de imagen - mitad superior
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            
            // Collection view - lower half / Vista de colección - mitad inferior
            collectionView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Album View Protocol Methods
    func showImages(_ images: [AlbumImageEntity]) {
        self.albumImages = images
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showSelectedImage(_ image: AlbumImageEntity) {
        DispatchQueue.main.async {
            self.mainImageView.image = UIImage(systemName: image.imageName)
        }
    }
}

// MARK: - Collection View Data Source
extension AlbumMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier,
                                                           for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let image = albumImages[indexPath.item]
        cell.configure(with: image)
        return cell
    }
}

// MARK: - Collection View Delegate
extension AlbumMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle image selection / Manejar selección de imagen
        presenter?.didSelectImage(at: indexPath.item)
    }
}

// MARK: - Collection View Flow Layout Delegate
extension AlbumMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 32
        return CGSize(width: height, height: height)
    }
}
