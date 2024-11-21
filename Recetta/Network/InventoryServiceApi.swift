//
//  InventoryServiceApi.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//


import Foundation

class InventoryService {
    func fetchInventoryByUserId(userId: String) async throws -> Inventory {
        try await ApiClient.shared.request(endpoint: "inventory/\(userId)", method: .GET)
        
    }
}

