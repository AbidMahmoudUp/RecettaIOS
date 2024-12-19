//
//  InventoryServiceApi.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//


import Foundation

class InventoryServiceApi {
    func fetchInventoryByUserId(userId: String) async throws -> Inventory {
        try await ApiClient.shared.request(endpoint: "inventory/\(userId)", method: .GET)
        
    }
    func updateInventoryByUserId(userId : String , ingredients: IngredientUpdateDto) async throws -> Inventory{
        try await ApiClient.shared.request(endpoint: "inventory/addIngredients/\(userId)", method: .PATCH , body: ingredients )
    }
    func startCooking(userId:String , ingredients: IngredientUpdateDto) async throws -> Inventory{
        try await ApiClient.shared.request(endpoint: "inventory/substractIngredients/\(userId)", method:.PATCH ,body: ingredients)
    }
    
    func updateInventoryWithImage(userId: String, file: MultipartFile) async throws -> Inventory {
        let boundary = UUID().uuidString
        let body = createMultipartBody(file: file, boundary: boundary)
        
        // Ensure the proper headers are set for multipart/form-data
        var headers: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Content-Length": "\(body.count)"
            
            // Add Authorization if needed (e.g., "Authorization": "Bearer token_here")
        ]
        print("File size: \(file.data.count) bytes")
        print("Request Body:\n\(String(data: body, encoding: .utf8) ?? "Unable to print body")")
        if let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body (as string):\n\(bodyString)")
        } else {
            print("Unable to print body as string, binary data may be involved.")
        }


        do{
            return try await ApiClient.shared.request(
                endpoint: "inventory/updateInventoryWithImage/\(userId)",
                method: .POST,
                body: body,
                headers: headers // Make sure headers are passed correctly
            )}catch {
            if let apiError = error as? ApiError {
                print("API Error: \(apiError)")
            } else {
                print("Unexpected error: \(error)")
            }
            throw error
        }
       }
    
    func scanRecipe(file: MultipartFile) async throws -> Recipe? {
        let boundary = UUID().uuidString
        let body = createMultipartBody(file: file, boundary: boundary)
        
        return try await ApiClient.shared.request(
            endpoint: "generative-ia-recipe",
            method: .POST,
            body: body,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )
    }
    
    private func createMultipartBody(file: MultipartFile, boundary: String) -> Data {
        var body = Data()

        // Boundary prefix
        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(boundaryPrefix.data(using: .utf8)!)

        // Content-Disposition header
        let disposition = "Content-Disposition: form-data; name=\"file\"; filename=\"\(file.filename)\"\r\n"
        body.append(disposition.data(using: .utf8)!)

        // Content-Type header
        let contentType = "Content-Type: \(file.mimeType)\r\n\r\n"
        body.append(contentType.data(using: .utf8)!)

        // Append the file data
        body.append(file.data)

        // Closing boundary
        let closingBoundary = "\r\n--\(boundary)--\r\n"
        body.append(closingBoundary.data(using: .utf8)!)

        return body
    }




}

