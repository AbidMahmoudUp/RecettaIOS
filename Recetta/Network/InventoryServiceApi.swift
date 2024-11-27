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
}

