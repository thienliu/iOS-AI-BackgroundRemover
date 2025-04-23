import UIKit
import Photos

protocol PhotoLibraryServiceProtocol {
    func checkPermission() async -> Bool
    func saveImage(_ image: UIImage) async throws
}

final class PhotoLibraryService: PhotoLibraryServiceProtocol {
    func checkPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            let newStatus = await requestAuthorization()
            return newStatus == .authorized || newStatus == .limited
        case .authorized, .limited:
            return true
        default:
            return false
        }
    }
    
    func saveImage(_ image: UIImage) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
    
    private func requestAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                continuation.resume(returning: newStatus)
            }
        }
    }
}
