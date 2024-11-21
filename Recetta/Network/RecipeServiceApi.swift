//
//  RecipeViewModel.swift
//  Recetta
//
//  Created by wicked on 21.11.24.
//

import Foundation

class RecipeServiceApi {
    func fetchRecipeById(recipeId: String) async throws -> Recipe {
        try await ApiClient.shared.request(endpoint: "plat/\(recipeId)", method: .GET)
        
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        try await ApiClient.shared.request(endpoint: "plat", method: .GET)
        
    }
}
