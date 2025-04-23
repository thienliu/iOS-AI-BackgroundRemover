import SwiftUI

struct ActionButtonView: View {
    @ObservedObject var vm: BackgroundRemovalViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            if vm.originalImage == nil {
                Button("Choose Image") {
                    vm.requestPhotoLibraryPermission()
                }
                .buttonStyle(.borderedProminent)
                .disabled(AppConfig.removeBG_APIKey.isEmpty)
            } else {
                if let processed = vm.outputImage {
                    Button("Save to Library") {
                        vm.saveImageToPhotoLibrary(image: processed)
                    }
                    .buttonStyle(.borderedProminent)

                } else {
                    Button(vm.isProcessing ? "Processing..." : "Remove Image Background") {
                        vm.removeBackground()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(vm.isProcessing)
                }
                
                Button("Start Over", role: .destructive) {
                    vm.clearImage()
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
        }
    }
}
