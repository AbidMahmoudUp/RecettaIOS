import Foundation

final class ApiClient {
    static let shared = ApiClient() // Singleton instance
    
    // private var token: String?
    
   
    
 
    
    // func setToken(_ token: String) {
    //    self.token = token
    //}
    
    // func clearToken() {
    //     self.token = nil
    //  }
    
    // private func getDefaultHeaders() -> [String: String] {
    //    var headers: [String: String] = ["Content-Type": "application/json"]
    //   if let token = token {
    //       headers["Authorization"] = "Bearer \(token)"
    //   }
    //    return headers
    //}
    
    func request<T: Decodable>(
        url: URL,
        method: HttpMethod,
        headers: [String: String]? = nil,
        body: Data? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        
     /*   let combinedHeaders = getDefaultHeaders().merging(headers ?? [:]) { (_, new) in new }
        combinedHeaders.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        */
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299: // Successful response
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                } else {
                    completion(.failure(.invalidResponse))
                }
            case 400...499:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            case 500...599:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
            default:
                completion(.failure(.invalidResponse))
            }
        }.resume()
    }
    
    func get<T: Decodable>(url: URL, headers: [String: String]? = nil, responseType: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        request(url: url, method: .get, headers: headers, responseType: responseType, completion: completion)
    }
    
    func post<T: Decodable>(url: URL, headers: [String: String]? = nil, body: Data?, responseType: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        request(url: url, method: .post, headers: headers, body: body, responseType: responseType, completion: completion)
    }
    
    func put<T: Decodable>(url: URL, headers: [String: String]? = nil, body: Data?, responseType: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        request(url: url, method: .put, headers: headers, body: body, responseType: responseType, completion: completion)
    }
    
    func delete<T: Decodable>(url: URL, headers: [String: String]? = nil, responseType: T.Type, completion: @escaping (Result<T, ApiError>) -> Void) {
        request(url: url, method: .delete, headers: headers, responseType: responseType, completion: completion)
    }
}
