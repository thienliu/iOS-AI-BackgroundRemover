import SwiftUI

struct MainView: View {
    @StateObject private var vm = BackgroundRemovalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                Spacer()
                if let originalImage = vm.originalImage {
                    ImageComparisonView(original: originalImage, processed: vm.outputImage)
                } else {
                    UploadPlaceholderView()
                }
                ActionButtonView(vm: vm)
                Spacer()
            }
            .padding()
            .alert(
                "Accessed Denied",
                isPresented: $vm.shouldShowPermissionAlert,
                actions: {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                },
                message: {
                    Text("Photo access is required to select an image.")
                }
            )
            .sheet(isPresented: $vm.isImagePickerAvailable) {
                ImagePickerView { image in
                    vm.pickImage(image)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
