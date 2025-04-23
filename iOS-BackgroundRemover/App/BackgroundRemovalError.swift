import Foundation

enum BackgroundRemovalError: Error {
    case imageEncodingFailed
    case imageTooLarge
    case invalidResponse
    case apiError(message: String)
    
    var errorDescription: String {
        switch self {
        case .imageEncodingFailed:
            "Failed to encode image to JPEG format."
        case .imageTooLarge:
            "The selected image is too large. Please choose one under 50MB."
        case .invalidResponse:
            "The server response could not be decoded into an image."
        case .apiError(let message):
            "API Error: \(message)"
        }
    }
}
