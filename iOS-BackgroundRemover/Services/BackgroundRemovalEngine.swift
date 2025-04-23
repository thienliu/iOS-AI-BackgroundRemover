import UIKit

protocol BackgroundRemovalEngine {
    func removeBackground(from image: UIImage) async throws -> UIImage
}
