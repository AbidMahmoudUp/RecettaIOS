//
//  InventoryRepository.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation

class InventoryRepository {
    private let service: InventoryService

    init(service: InventoryService = InventoryService()) {
        self.service = service
    }

    func getInventoryByUserId(userId: String) async throws -> Inventory {
        try await service.fetchInventoryByUserId(userId: userId)
    }
}
