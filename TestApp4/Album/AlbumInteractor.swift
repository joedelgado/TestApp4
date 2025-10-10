// AlbumInteractor.swift
// Interactor for the Album module (VIPER)
// Lógica de negocio del módulo Album

import UIKit

// MARK: - Album Interactor Protocol
protocol AlbumInteractorProtocol: AnyObject {
    var presenter: AlbumPresenterProtocol? { get set }
    func fetchAlbumImages()
    func selectImage(at index: Int)
}

// MARK: - Album Interactor Implementation
class AlbumInteractor: AlbumInteractorProtocol {
    weak var presenter: AlbumPresenterProtocol?
    
    private var albumImages: [AlbumImageEntity] = []
    private var selectedImageIndex: Int = 0
    
    // Fetch album images / Obtener imágenes del álbum
    func fetchAlbumImages() {
        albumImages = AlbumDataSource.getSampleImages()
        presenter?.didFetchImages(albumImages)
        
        // Set first image as selected by default
        if !albumImages.isEmpty {
            presenter?.didSelectImage(albumImages[selectedImageIndex])
        }
    }
    
    // Handle image selection / Manejar selección de imagen
    func selectImage(at index: Int) {
        guard index >= 0 && index < albumImages.count else { return }
        
        selectedImageIndex = index
        let selectedImage = albumImages[index]
        presenter?.didSelectImage(selectedImage)
    }
}
