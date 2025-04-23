import PhotosUI
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    var onImagePicked: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> some PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
  
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> PHPickerCoordinator {
        PHPickerCoordinator(onImagePicked: onImagePicked)
    }
}

final class PHPickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    var onImagePicked: (UIImage) -> Void
    
    init(onImagePicked: @escaping (UIImage) -> Void) {
        self.onImagePicked = onImagePicked
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        provider.loadObject(ofClass: UIImage.self) { object, _ in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.onImagePicked(image)
                }
            }
        }
    }
}
