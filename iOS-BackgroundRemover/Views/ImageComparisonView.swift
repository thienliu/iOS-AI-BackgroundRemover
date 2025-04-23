import SwiftUI

struct ImageComparisonView: View {
    let original: UIImage
    let processed: UIImage?
    
    var body: some View {
        HStack(spacing: 16) {
            SingleImageView(title: processed != nil ? "Before" : "Selected Image", image: original)
            if let processed {
                SingleImageView(title: "After", image: processed)
            }
        }
    }
}

struct SingleImageView: View {
    let title: String
    let image: UIImage
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline.bold())
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 0.5)
                }
        }
    }
}
