// AlbumPresenter.swift
// Presenter for the Album module (VIPER)
// Lógica de presentación del módulo Album

import UIKit

// MARK: - Album Presenter Protocol
// Protocolo para la comunicación del Presenter
// Protocol for Presenter communication
protocol AlbumPresenterProtocol: AnyObject {
    var view: AlbumViewProtocol? { get set }
    var interactor: AlbumInteractorProtocol? { get set }
    var router: AlbumRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectImage(at index: Int)
    func didFetchImages(_ images: [AlbumImageEntity])
    func didSelectImage(_ image: AlbumImageEntity)
}

// MARK: - Album Presenter Implementation
// Implementación del Presenter para el módulo Album
// Implementation of the Presenter for the Album module
class AlbumPresenter: AlbumPresenterProtocol {
    weak var view: AlbumViewProtocol?
    var interactor: AlbumInteractorProtocol?
    var router: AlbumRouterProtocol?
    
    // MARK: - Presentation Logic Methods
    
    // View did load / Vista cargada
    func viewDidLoad() {
        interactor?.fetchAlbumImages()
    }
    
    // User selected image in collection / Usuario seleccionó imagen en colección
    func didSelectImage(at index: Int) {
        interactor?.selectImage(at: index)
    }
    
    // Interactor fetched images / Interactor obtuvo imágenes
    func didFetchImages(_ images: [AlbumImageEntity]) {
        view?.showImages(images)
    }
    
    // Interactor selected image / Interactor seleccionó imagen
    func didSelectImage(_ image: AlbumImageEntity) {
        view?.showSelectedImage(image)
    }
}
