import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Remove Image Background")
                .font(.title2.bold())
            Text("Powered by AI using Remove.bg")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if AppConfig.removeBG_APIKey.isEmpty {
                Text("API key is missing. Obtain yours at remove.bg and set it in AppConfig.swift")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .multilineTextAlignment(.center)
    }
}
