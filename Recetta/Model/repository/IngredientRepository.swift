//
//  IngredientRepository.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation

class IngredientRepository {
    private let service: IngredientServiceApi

    init(service: IngredientServiceApi = IngredientServiceApi()) {
        self.service = service
    }

    func getInventoryByUserId(ingredientId: String) async throws -> Ingredient {
        try await service.fetchIngredientById(ingredientId: ingredientId)
    }
    
    func getingredients() async throws -> [Ingredient]  {
        try await service.fetchIngredients()
    }
    
}
