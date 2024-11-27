import Foundation

class ApiClient {
    static let shared = ApiClient()
    private init() {}

    private let baseURL = "https://080d-102-156-55-70.ngrok-free.app/api"
    private let defaultHeaders = ["Content-Type": "application/json"]

    func request<T: Decodable>(
        endpoint: String,
        method: HttpMethod,
        body: Encodable? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        // Construct the full URL
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw ApiError.invalidURL
        }

        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders.merging(headers) { (_, new) in new }

        // Encode the body if provided
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
            print(String(data: data, encoding: .utf8)!)

            // Decode the response data
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw ApiError.decodingError
            }
        } catch {
            if let apiError = error as? ApiError {
                throw apiError // Pass through known ApiErrors
            }
            throw ApiError.networkError(error) // Wrap unknown errors
        }
    }
}
