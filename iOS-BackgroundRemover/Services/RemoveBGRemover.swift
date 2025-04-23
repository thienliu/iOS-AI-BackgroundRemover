import UIKit

final class RemoveBGRemover: BackgroundRemovalEngine {
    func removeBackground(from image: UIImage) async throws -> UIImage {
        // Convert UIImage to data for validation
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            throw BackgroundRemovalError.imageEncodingFailed
        }
        
        // Verify file size is within 22MB limit
        guard imageData.count < AppConfig.imageMaxSizeInBytes else {
            throw BackgroundRemovalError.imageTooLarge
        }
        
        return try await uploadImage(imageData: imageData)
    }
    
    func createMultipartBody(imageData: Data, boundary: String) -> Data {
        var body = Data()

        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"file.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    func uploadImage(imageData: Data) async throws -> UIImage {
        let url = URL(string: "https://api.remove.bg/v1.0/removebg")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(AppConfig.removeBG_APIKey, forHTTPHeaderField: "X-Api-Key")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createMultipartBody(imageData: imageData, boundary: boundary)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let apiMessage = String(data: data, encoding: .utf8) ?? "Unknown API error"
            throw BackgroundRemovalError.apiError(message: apiMessage)
        }

        guard let outputImage = UIImage(data: data) else {
            throw BackgroundRemovalError.invalidResponse
        }
        
        return outputImage
    }
}
