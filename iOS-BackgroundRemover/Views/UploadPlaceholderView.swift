import SwiftUI

struct UploadPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundStyle(.gray)
            Text("No image selected")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background(Color.secondary.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.vertical)
    }
}
