//
//  InventoryRepository.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation

class InventoryRepository {
    private let service: InventoryServiceApi

    init(service: InventoryServiceApi = InventoryServiceApi()) {
        self.service = service
    }

    
    
    func getInventoryByUserId(userId: String) async throws -> Inventory {
        try await service.fetchInventoryByUserId(userId: userId)
    }
    
    
    
    func updateInventoryByUserId(userId : String,ingredients: IngredientUpdateDto) async throws ->Inventory
    {
        try await service.updateInventoryByUserId(userId: userId, ingredients: ingredients)
    }
    
    
    
    func startCooking(userId: String , ingredients : IngredientUpdateDto) async throws ->Inventory
    {
        try await service.startCooking(userId: userId, ingredients: ingredients)
    }
}
