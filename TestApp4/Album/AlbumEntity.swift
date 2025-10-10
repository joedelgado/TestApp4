// AlbumEntity.swift
// Entity for the Album module (VIPER)
// Modelo de datos para el módulo Album
import UIKit

// MARK: - Album Image Entity
// Entidad que representa una imagen del álbum
struct AlbumImageEntity {
    let id: Int
    let imageName: String
    let title: String?
    
    init(id: Int, imageName: String, title: String? = nil) {
        self.id = id
        self.imageName = imageName
        self.title = title
    }
}

// MARK: - Album Data Source
// Fuente de datos para el álbum con imágenes predeterminadas
class AlbumDataSource {
    
    // Generate sample images / Generar imágenes de muestra
    static func getSampleImages() -> [AlbumImageEntity] {
        var images: [AlbumImageEntity] = []
        
        // Using SF Symbols for consistent look / Usando SF Symbols para apariencia consistente
        let systemImages = [
            "photo.fill",
            "camera.fill",
            "heart.fill",
            "star.fill",
            "moon.fill",
            "sun.max.fill",
            "cloud.fill",
            "leaf.fill"
        ]
        
        for (index, imageName) in systemImages.enumerated() {
            let image = AlbumImageEntity(
                id: index + 1,
                imageName: imageName,
                title: "Image \(index + 1)"
            )
            images.append(image)
        }
        
        return images
    }
}
