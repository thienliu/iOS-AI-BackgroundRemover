import Photos
import SwiftUI

@MainActor
final class BackgroundRemovalViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var outputImage: UIImage?
    @Published var isProcessing = false
    @Published var errorMessage: String?
    
    @Published var isImagePickerAvailable = false
    @Published var shouldShowPermissionAlert = false
    
    private let remover: BackgroundRemovalEngine
    private let photoLibraryService: PhotoLibraryServiceProtocol
    
    init(
        remover: BackgroundRemovalEngine = RemoveBGRemover(),
        photoLibraryService: PhotoLibraryServiceProtocol = PhotoLibraryService()
    ) {
        self.remover = remover
        self.photoLibraryService = photoLibraryService
    }
    
    // MARK: Photo Library
    func requestPhotoLibraryPermission() {
        Task {
            let granted = await photoLibraryService.checkPermission()
            if granted {
                isImagePickerAvailable = true
            } else {
                shouldShowPermissionAlert = true
            }
        }
    }
    
    func pickImage(_ image: UIImage) {
        if image.jpegData(compressionQuality: 1.0)?.count ?? 0 < AppConfig.imageMaxSizeInBytes {
            originalImage = image
            outputImage = nil
            errorMessage = nil
        } else {
            errorMessage = "Image exceeds 22MB limit"
        }
    }
    
    func saveImageToPhotoLibrary(image: UIImage) {
        Task {
            do {
                try await photoLibraryService.saveImage(image)
            } catch {
                errorMessage = "Failed to save image: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: View Model Tasks
    func removeBackground() {
        Task {
            guard let image = originalImage else { return }
            isProcessing = true
            errorMessage = nil
            
            do {
                let result = try await remover.removeBackground(from: image)
                outputImage = result
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isProcessing = false
        }
    }
    
    func clearImage() {
        originalImage = nil
        outputImage = nil
        errorMessage = nil
    }
}
