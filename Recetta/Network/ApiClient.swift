import Foundation

class ApiClient {
    static let shared = ApiClient()
    private init() {}

    private let defaultHeaders = ["Content-Type": "application/json"]

    func request<T: Decodable>(
        endpoint: String,
        method: HttpMethod,
        body: Encodable? = nil,
        headers: [String: String] = [:],
        contentType: String? = nil // Allow custom Content-Type

    ) async throws -> T {
        // Construct the full URL
        guard let url = URL(string: "\(Constants.baseURL)/\(endpoint)") else {
            throw ApiError.invalidURL
        }

        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders.merging(headers) { (_, new) in new }

        // Encode the body if provided
        
        if let contentType = contentType {
               request.setValue(contentType, forHTTPHeaderField: "Content-Type")
           }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw ApiError.encodingError(error)
            }
        }

        // Execute the network request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Validate the HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.unknown
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw ApiError.serverError(httpResponse.statusCode)
            }

            // Print raw JSON data for debugging
            print("Raw JSON response: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")

            // Decode the response data with detailed error handling
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
                throw ApiError.decodingError // Adjusted to handle specific decoding error
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type mismatch for type \(type): \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
                throw ApiError.decodingError
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value not found: \(value), context: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
                throw ApiError.decodingError
            } catch DecodingError.dataCorrupted(let context) {
                print("Data corrupted: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
                throw ApiError.decodingError
            } catch {
                print("General decoding error: \(error.localizedDescription)")
                throw ApiError.decodingError
            }
        } catch let error as ApiError {
            throw error // Pass through known ApiErrors
        } catch {
            throw ApiError.networkError(error) // Wrap unknown errors
        }
    }
}
