//
//  IngredientServiceApi.swift
//  Recetta
//
//  Created by wicked on 26.11.24.
//

import Foundation
class IngredientServiceApi {
    func fetchIngredientById(ingredientId: String) async throws -> Ingredient {
        try await ApiClient.shared.request(endpoint: "ingredient/\(ingredientId)", method: .GET)
        
    }
    
    func fetchIngredients() async throws -> [Ingredient] {
        let ingredients: [Ingredient] = try await ApiClient.shared.request(endpoint: "ingredient", method: .GET)
        print("Fetched Ingredients: \(ingredients)") 
        return ingredients
    }

}
